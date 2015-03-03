class AddAttachmentAvatarToCharities < ActiveRecord::Migration
  def self.up
    change_table :charity do |t|
      t.attachment :logo
      
    end
  end

  def self.down
    remove_attachment :charity, :logo
  end
end
