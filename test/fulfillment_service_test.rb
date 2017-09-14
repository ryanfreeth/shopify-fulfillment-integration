require 'test_helper'
require './lib/models/fulfillment_service'
require './lib/models/shop_item'

class FulfillmentServiceTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_formatting
    shop_name = "testshop.myshopify.com"
    fulfillment_webhook = load_fixture 'fulfillment_webhook.json'
    fulfillment = JSON.parse(fulfillment_webhook, object_class: OpenStruct)
    order_response = load_fixture('order.json')
    order = JSON.parse(order_response, object_class: OpenStruct)
    shop_item = ShopItem.new; shop_item.sku = 'clown:16x24-SB'
    ShopItem.stubs(:find).returns(shop_item)

    service = FulfillmentService.new
    service.fulfill(order.order, fulfillment)
  end
end