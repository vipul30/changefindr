class AddStripeToDonations < ActiveRecord::Migration
  def change
  	add_column :donations, :stripe_response, :json
  	add_column :donations, :amount, :decimal
  end
end
