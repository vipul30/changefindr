class Newsletter < ActiveRecord::Base

    self.primary_key = :newsletterid

    belongs_to :user, :class_name => 'User', :foreign_key => :userid

    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	validates :email, :presence => { :message => "Please provide your email." },
	                    :length => { :maximum => 100 },
	                    :format => EMAIL_REGEX
	                    

   
end
