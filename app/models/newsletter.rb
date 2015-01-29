class Newsletter < ActiveRecord::Base
    self.table_name = 'newsletter'
    self.primary_key = :newsletterid

    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	validates :email, :presence => { :message => "Please provide your email." },
	                    :length => { :maximum => 100 },
	                    :format => EMAIL_REGEX
	                    

    belongs_to :user, :class_name => 'User', :foreign_key => :userid
end
