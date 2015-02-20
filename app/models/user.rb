class User < ActiveRecord::Base
    self.table_name = 'user'
    self.primary_key = :userid

    belongs_to :role, :class_name => 'Role', :foreign_key => :roleid

	EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

	# shortcut validations, aka "sexy validations"
	  validates :firstname, :presence => { :message => "Please enter your first name." },
	                        :length => { :maximum => 25, :message => "First name must be less than 25 characters." }
	                        
	                         
	  validates :lastname, :presence => true,
	                        :length => { :maximum => 25, :message => "First name must be less than 25 characters." }
	                       
	  validates :email, :presence => { :message => "Please provide your email." },
	                    :length => { :maximum => 100 },
	                    :format => EMAIL_REGEX,
	                    :confirmation => true,
	                    :uniqueness => { :message => "There is already a user with this email." }

end
