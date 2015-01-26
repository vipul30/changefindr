class Giftcard < ActiveRecord::Base
	self.table_name = 'giftcard'
    self.primary_key = :giftcardid
    attr_accessor :cardnumber

    belongs_to :merchant, :class_name => 'Merchant', :foreign_key => :merchantid
    belongs_to :user, :class_name => 'User', :foreign_key => :userid

    validates :merchantid, :presence => { :message => "Please enter your gift card." }

    validates :cardnumber, :presence => { :message => "Please enter the gift card number" },
	                        :length => { :maximum => 50 }
	                        
end
