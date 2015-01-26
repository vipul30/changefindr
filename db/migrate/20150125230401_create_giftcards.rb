class CreateGiftcard < ActiveRecord::Migration
  def change
    create_table :giftcard do |t|

      t.timestamps
    end
  end
end
