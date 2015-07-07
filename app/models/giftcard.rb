class Giftcard < ActiveRecord::Base

    self.primary_key = :giftcardid

    belongs_to :user, :class_name => 'User', :foreign_key => :userid
    has_many :donations, :class_name => 'Donation', :foreign_key => :giftcardid
    belongs_to :merchant, :class_name => 'Merchant', :foreign_key => :merchantid
    has_many :bhnquotes, :class_name => 'Bhnquote', :foreign_key => :giftcardid

    attr_encrypted :cardnumber, :key => 'dkghiu39857dhgkjh'
    attr_encrypted :pin, :key => 'sdkjghoi8907dfkjhk'

	validates :merchantid, :presence => { :message => "Please enter your gift card." }

    validates :cardnumber, :presence => { :message => "Please enter the gift card number" },
	                        :length => { :maximum => 50 }

	def self.search(search, page)
	  paginate :per_page => 9, :page => page
	           
	end

end
