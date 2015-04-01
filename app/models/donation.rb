class Donation < ActiveRecord::Base
	self.table_name = 'donation'
    self.primary_key = :donationid
    
    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

   

    belongs_to :charity, :class_name => 'Charity', :foreign_key => :charityid
    belongs_to :user, :class_name => 'User', :foreign_key => :userid
    belongs_to :giftcard, :class_name => 'Giftcard', :foreign_key => :giftcardid

    accepts_nested_attributes_for :giftcard, update_only: true

    validates :firstname, :presence => {:message => "Please enter your first name."}, :unless => :userid?
    validates :lastname, :presence => {:message => "Please enter your last name."}, :unless => :userid?
 	validates :email, :presence => {:message => "Please enter a valid email address."}, 
 						  			:unless => :userid?,
 						  			:format => EMAIL_REGEX
	
        
	                        
end
