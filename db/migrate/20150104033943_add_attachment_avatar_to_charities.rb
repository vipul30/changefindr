class AddAttachmentAvatarToCharities < ActiveRecord::Migration
  def self.up
    change_table :charity do |t|
      t.attachment :avatar
      
    end
  end

  def self.down
    remove_attachment :charity, :avatar
  end
end
