require 'sinatra/shopify-sinatra-app'
require 'attr_encrypted'
require 'active_fulfillment'
require_relative 'shop_item'

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
      test: false,
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
      shop_item = get_shop_item(line.sku)
      line.quantity.to_i.times do
        items << line_item(line, shop_item.edition, shop_item.total_editions)
        shop_item.edition += 1
      end
      shop_item.save
    end
    items.compact
  end

  def line_item(line, edition, total_edition)
    {
      sku: line.sku.split(':')[1],
      quantity: 1,
      description: "#{line.title}. Edition #{edition} of #{total_edition}",
      price: line.price,
      url: image_url(line.sku)
    }
  end

  def get_shop_item(sku)
    title = sku.split(':')[0]
    nw_sku = sku.split(':')[1]
    size = nw_sku.split('-')[0]
    ShopItem.where(title: title, size: size).take
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
      note: order.note
    }
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
