class AccountTransaction < ActiveRecord::Base



    belongs_to :account, :class_name => 'Account', :foreign_key => :account_id
    has_many :bhnacquires, :class_name => 'Bhnacquire'
    has_many :bhnquotes, :class_name => 'Bhnquote'
    has_many :donations, :class_name => 'Donation'
    has_many :giftcards, :class_name => 'Giftcard'
end
