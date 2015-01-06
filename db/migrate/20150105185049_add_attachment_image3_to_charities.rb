class AddAttachmentImage3ToCharities < ActiveRecord::Migration
  def self.up
    change_table :charity do |t|
      t.attachment :image3
    end
  end

  def self.down
    remove_attachment :charity, :image3
  end
end
