class Role < ActiveRecord::Base

    self.primary_key = :roleid

    has_many :users, :class_name => 'User', :foreign_key => :roleid
end
