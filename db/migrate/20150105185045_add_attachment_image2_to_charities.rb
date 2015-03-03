class AddAttachmentImage2ToCharities < ActiveRecord::Migration
  def self.up
    change_table :charity do |t|
      t.attachment :image2
    end
  end

  def self.down
    remove_attachment :charity, :image2
  end
end
