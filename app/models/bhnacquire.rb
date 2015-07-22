class Bhnacquire < ActiveRecord::Base
    self.table_name = 'bhnacquire'
    self.primary_key = :bhnacquireid

    belongs_to :donation, :class_name => 'Donation', :foreign_key => :donationid
    belongs_to :account_transaction, :class_name => 'AccountTransaction', :foreign_key => :account_transaction_id
end
