class User < ActiveRecord::Base
    self.table_name = 'user'
    self.primary_key = :userid

	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	# shortcut validations, aka "sexy validations"
	  validates :firstname, :presence,

	                         :length => { :maximum => 25 }
	                         
	  validates :lastname, :presence => true,
	                        :length => { :maximum => 50 }
	                       
	  validates :email, :presence => true,
	                    :length => { :maximum => 100 },
	                    :format => EMAIL_REGEX,
	                    :confirmation => true,
	                    :uniqueness => true

end
