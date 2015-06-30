class BlogComment < ActiveRecord::Base

    belongs_to :user, :class_name => 'User', :foreign_key => :user_id
    belongs_to :blog, :class_name => 'Blog', :foreign_key => :blog_id
end
