class User < ActiveRecord::Base
    self.table_name = 'user'
    self.primary_key = :userid

    belongs_to :role, :class_name => 'Role', :foreign_key => :roleid
    has_many :giftcards, :class_name => 'Giftcard', :foreign_key => :userid
    has_many :newsletters, :class_name => 'Newsletter', :foreign_key => :userid
    has_many :donations, :class_name => 'Donation', :foreign_key => :userid
    has_many :blogs, :class_name => 'Blog'
    has_many :blog_comments, :class_name => 'BlogComment'
    belongs_to :account, :class_name => 'Account', :foreign_key => :account_id

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
