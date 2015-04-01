class Bhnacquire < ActiveRecord::Base
    self.table_name = 'bhnacquire'
    self.primary_key = :bhnacquireid

    belongs_to :donation, :class_name => 'Donation', :foreign_key => :donationid
end
