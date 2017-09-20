require 'sinatra/shopify-sinatra-app'
require 'attr_encrypted'
require 'active_fulfillment'
require_relative 'shop_item'
require_relative 'edition'

# This is the fulfillment service model. It holds all of the data
# associated with the service such as the shop it belongs to and the
# credentials (encrypted). It also contains some methods to help translate
# the fulfillment data from a Shopify format into the format expected by the
# fulfillment service.

class FulfillmentService < ActiveRecord::Base
  def self.secret
    ENV['SECRET']
  end

  attr_encrypted :username, key: secret, attribute: 'username_encrypted'
  attr_encrypted :password, key: secret, attribute: 'password_encrypted'
  validates_presence_of :username, :password, :role
  validates :shop, uniqueness: true
  before_save :check_credentials, unless: 'Sinatra::Base.test?'

  def self.service_name
    'nw-fulfillment'
  end

  def fulfill(order, fulfillment)
    response = instance.fulfill(
      order.id,
      address(order.shipping_address),
      line_items(order, fulfillment),
      fulfill_options(order, fulfillment)
    )

    response.success?
  end

  def fetch_stock_levels(options = {})
    instance.fetch_stock_levels(options)
  end

  def fetch_tracking_numbers(order_ids)
    instance.fetch_tracking_numbers(order_ids)
  end

  private

  def instance
    @instance ||= ActiveFulfillment::NWFramingService.new(
      login: username,
      password: password,
      role: role,
      test: true,
      include_empty_stock: true
    )
  end

  def address(address_object)
    {
      name: address_object.name,
      company: address_object.company,
      address1: address_object.address1,
      address2: address_object.address2,
      phone: address_object.phone,
      city: address_object.city,
      state: address_object.province_code,
      country: address_object.country_code,
      zip: address_object.zip
    }
 end

  def line_items(order, fulfillment)
    items = []
    fulfillment.line_items.each do |line|
      next unless line.quantity > 0
      items << line_item(line)
    end
    items.compact
  end

  def line_item(line)
    {
      sku: get_shop_item(line.sku)[:nw_sku],
      image_id: line.title,
      quantity: line.quantity,
      description: line.title,
      price: line.price,
      url: image_url(line.sku)
    }
  end

  def get_shop_item(sku)
    ShopItem.find_by(shop: shop, sku: sku)
  end

  def image_url(sku)
    get_shop_item(sku).url
  end

  def fulfill_options(order, fulfillment)
    {
      order_date: order.created_at,
      comment: 'Thank you for your purchase',
      email: order.email,
      tracking_number: fulfillment.tracking_number,
      shipping_method: 'Ground',
      note: order.note,
      special_instructions: special_instructions(fulfillment)
    }
  end

  def special_instructions(fulfillment)
    # foreach line item, increment edition in transaction, build string of instructions
    special_instructions = ''
    fulfillment.line_items.each do |line|
      Edition.transaction do
        next unless line.quantity > 0
        shop_item = get_shop_item(line.sku)
        if shop_item.edition.present?
          line.quantity.to_i.times do
            special_instructions << "#{line.name} edition #{shop_item.edition.edition} of #{shop_item.edition.total_editions}. "
            shop_item.edition.edition += 1
            shop_item.edition.save
          end
        end
      end
    end
    special_instructions
  end

  def shipping_code(label)
    methods = ActiveFulfillment::NWFramingService.shipping_methods
    methods.each { |title, code| return code if title.casecmp(label.to_s.downcase).zero? }
    label # make sure to never send an empty shipping method to Shipwire
  end

  def check_credentials
    unless instance.valid_credentials?
      errors.add(:password, 'Must have valid NorthWest Framing credentials to use the services provided by this app.')
      false
    end
  end
end
