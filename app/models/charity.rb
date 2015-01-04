class Charity < ActiveRecord::Base
    self.table_name = 'charity'
    self.primary_key = :charityid
	has_attached_file :avatar , {
		
		:path => ":rails_root/public/images/cause/:basename.:extension"
	}
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
    has_many :campaigns, :class_name => 'Campaign', :foreign_key => :charityid
end
