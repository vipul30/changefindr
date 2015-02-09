class Donation < ActiveRecord::Base
	self.table_name = 'donation'
    self.primary_key = :donationid
    

    belongs_to :charity, :class_name => 'Charity', :foreign_key => :charityid
    belongs_to :user, :class_name => 'User', :foreign_key => :userid
    belongs_to :giftcard, :class_name => 'Giftcard', :foreign_key => :giftcardid

    accepts_nested_attributes_for :giftcard
        
	                        
end
