class Giftcard < ActiveRecord::Base
	self.table_name = 'giftcard'
    self.primary_key = :giftcardid
    

    belongs_to :merchant, :class_name => 'Merchant', :foreign_key => :merchantid
    belongs_to :user, :class_name => 'User', :foreign_key => :userid

    validates :merchantid, :presence => { :message => "Please enter your gift card." }

    validates :cardnumber_hash, :presence => { :message => "Please enter the gift card number" },
	                        :length => { :maximum => 50 }

	def self.search(search, page)
	  paginate :per_page => 9, :page => page
	           
	end
	                        
end
