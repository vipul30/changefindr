class Campaign < ActiveRecord::Base
    self.table_name = 'campaign'
    self.primary_key = :campaignid

    belongs_to :charity, :class_name => 'Charity', :foreign_key => :charityid
end
