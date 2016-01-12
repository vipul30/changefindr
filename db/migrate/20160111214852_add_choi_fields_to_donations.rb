class AddChoiFieldsToDonations < ActiveRecord::Migration
  def change
  	add_column :donations, :address, :string
  	add_column :donations, :occupation, :string
  	add_column :donations, :employer, :string
  end
end
