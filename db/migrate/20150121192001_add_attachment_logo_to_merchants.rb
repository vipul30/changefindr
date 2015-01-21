class AddAttachmentLogoToMerchants < ActiveRecord::Migration
  def self.up
    change_table :merchant do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :merchant, :logo
  end
end
