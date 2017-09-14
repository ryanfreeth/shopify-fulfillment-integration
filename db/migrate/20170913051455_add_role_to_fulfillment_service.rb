class AddRoleToFulfillmentService < ActiveRecord::Migration[5.1]
  def change
    add_column :fulfillment_services, :role, :string
  end
end
