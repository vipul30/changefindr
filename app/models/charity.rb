class Charity < ActiveRecord::Base
    self.table_name = 'charity'
    self.primary_key = :charityid

    has_many :campaigns, :class_name => 'Campaign', :foreign_key => :charityid
end
