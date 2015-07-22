class AccountUrl < ActiveRecord::Base



    belongs_to :account, :class_name => 'Account', :foreign_key => :account_id
end
