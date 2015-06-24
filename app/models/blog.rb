class Blog < ActiveRecord::Base
    self.table_name = 'blog'
    self.primary_key = :blog_id

    belongs_to :user, :class_name => 'User', :foreign_key => :user_id
    has_many :blog_comments, :class_name => 'BlogComment', :foreign_key => :blog_id
end
