class Blog < ActiveRecord::Base
    self.table_name = 'blog'
    self.primary_key = :blog_id

    belongs_to :user, :class_name => 'User', :foreign_key => :user_id
    has_many :blog_comments, :class_name => 'BlogComment', :foreign_key => :blog_id


    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

    validates :first_name, :presence => { :message => "Please enter your first name." },
	                        :length => { :maximum => 50, :message => "First name must be less than 50 characters." }

    validates :last_name, :presence => { :message => "Please enter your last name." },
    					    :length => { :maximum => 50, :message => "Last name must be less than 50 characters." }

     validates :title, :presence => { :message => "Please enter title of blog" },
    					    :length => { :maximum => 50, :message => "Title must be less than 50 characters." }

    validates :description, :presence => { :message => "Please enter a description." },
    					    :length => { :maximum => 50000, :message => "Description is too long." }

	validates :email, :presence => {:message => "Please enter a valid email address."},  						  			
 						  			:format => EMAIL_REGEX    



end
