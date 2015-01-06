class Charity < ActiveRecord::Base
    self.table_name = 'charity'
    self.primary_key = :charityid
	has_attached_file :logo , {	
		:path => ":rails_root/public/images/cause/:basename.#{Time.now}.:extension"
	}

	has_attached_file :image1 , {	
		:path => ":rails_root/public/images/cause/:basename.#{Time.now}.:extension"
	}

	has_attached_file :image2 , {	
		:path => ":rails_root/public/images/cause/:basename.#{Time.now}.:extension"
	}

	has_attached_file :image3 , {	
		:path => ":rails_root/public/images/cause/:basename.#{Time.now}.:extension"
	}

	validates :charityname, :presence => { :message => "Please enter the name of your cause." },
	                        :length => { :maximum => 25 }

	validates :description, :presence => { :message => "Please enter a description for your cause." },
	                        :length => { :maximum => 5000, :message => "Description must be less than 5000 characters." }

	validates :website, :presence => { :message => "Please enter the website of your cause." },
						:url => { :message => "Please enter a valid website.  i.e. http://www.changefindr.com" }

	validates :facebookurl, :url => {:allow_blank => true, 
									 :message => "Please enter a valid website.  i.e. http://www.facebook.com"}

	validates :logo, :presence=> { :message => "Please upload an image of your logo." }
	validates_attachment_size :logo, :less_than => 2.megabytes, :message => "Please ensure size of the logo image is less than 2MB." 
	validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/,  :message => "Invalid image type for logo." 
	

	validates_attachment_size :image1, :less_than => 2.megabytes, :message => "Please ensure size of banner image 1 is less than 2MB." 
	validates_attachment_content_type :image1, :content_type => /\Aimage\/.*\Z/,  :message => "Invalid image type for first banner." 

	validates_attachment_size :image2, :less_than => 2.megabytes, :message => "Please ensure size of banner image 2 is less than 2MB." 
	validates_attachment_content_type :image2, :content_type => /\Aimage\/.*\Z/,  :message => "Invalid image type for second banner." 

	validates_attachment_size :image3, :less_than => 2.megabytes, :message => "Please ensure size of banner image 3 is less than 2MB." 
	validates_attachment_content_type :image3, :content_type => /\Aimage\/.*\Z/,  :message => "Invalid image type for third banner." 

    has_many :campaigns, :class_name => 'Campaign', :foreign_key => :charityid
end
