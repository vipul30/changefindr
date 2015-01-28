class CreateGiftcardstat < ActiveRecord::Migration
  def change
    create_table :giftcardstat do |t|

      t.timestamps
    end
  end
end
