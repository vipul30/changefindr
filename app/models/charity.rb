class Charity < ActiveRecord::Base
    self.table_name = 'charity'
    self.primary_key = :charityid
	has_attached_file :logo, {	styles: {thumb: "75x75#"},
								:path => "Users/vipul/Sites/changefindr/public/images/photo_attachment/:id/:style/:basename.:extension",
								:url => "/images/photo_attachment/:id/:style/:basename.:extension",
								:default_url => "/images/photo_attachment/missing_thumb.png",
								:storage => :s3,
  								:s3_credentials => {
								    :bucket => 'changefindr.com',
								    :access_key_id => ACCESS_KEY_ID,
								    :secret_access_key => SECRET_ACCESS_KEY
								  },
								:access_key_id => ACCESS_KEY_ID,
								:secret_access_key => SECRET_ACCESS_KEY,
            					:s3_host_name => 's3-us-west-1.amazonaws.com',
            					:bucket => 'changefindr.com',
								:size => { :in => 0..500.kilobytes } }

	has_attached_file :image1 , {	styles: {thumb: "60x60#"},
									:path => "Users/vipul/Sites/changefindr/public/images/photo_attachment/:id/:style/:basename.:extension",
									:url => "/images/photo_attachment/:id/:style/:basename.:extension",
									:default_url => "/images/photo_attachment/missing_thumb.png",
									:size => { :in => 0..500.kilobytes }
								}

	has_attached_file :image2, {	styles: {thumb: "60x60#"},
								:path => "Users/vipul/Sites/changefindr/public/images/photo_attachment/:id/:style/:basename.:extension",
								:url => "/images/photo_attachment/:id/:style/:basename.:extension",
								:default_url => "/images/photo_attachment/missing_thumb.png",
								:size => { :in => 0..500.kilobytes }
							    }

	has_attached_file :image3, {styles: {thumb: "60x60#"},
								:path => "Users/vipul/Sites/changefindr/public/images/photo_attachment/:id/:style/:basename.:extension",
								:url => "/images/photo_attachment/:id/:style/:basename.:extension",
								:default_url => "/images/photo_attachment/missing_thumb.png",
								:size => { :in => 0..600.kilobytes }
								 }

	validates :charityname, :presence => { :message => "Please enter the name of your cause." },
	                        :length => { :maximum => 50 }

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

	def self.search(search, page)
	  paginate :per_page => 9, :page => page,
	           :conditions => ['charityname like ?', "%#{search}%"], :order => 'charityname'
	end

end
