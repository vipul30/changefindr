class AddAttachmentImage1ToCharities < ActiveRecord::Migration
  def self.up
    change_table :charity do |t|
      t.attachment :image1
    end
  end

  def self.down
    remove_attachment :charity, :image1
  end
end
