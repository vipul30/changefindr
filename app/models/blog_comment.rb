class BlogComment < ActiveRecord::Base
    self.table_name = 'blog_comment'
    self.primary_key = :comment_id

    belongs_to :user, :class_name => 'User', :foreign_key => :user_id
    belongs_to :blog, :class_name => 'Blog', :foreign_key => :blog_id
end
