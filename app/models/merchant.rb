class Merchant < ActiveRecord::Base
    self.table_name = 'merchant'
    self.primary_key = :merchantid

	validates :merchantname, :presence => { :message => "Please enter the merchant name." },
	                        :length => { :maximum => 50 }

	validates :checkbalanceurl, :presence => { :message => "Please enter the website to check balance" },
						:url => { :message => "Please enter a valid website.  i.e. http://www.changefindr.com" }

    has_attached_file :logo, {	styles: {thumb: "75x75#"},
								:path => "#{Rails.root}/public/images/photo_attachment/:id/:style/:basename.:extension",
								:url => "/images/photo_attachment/:id/:style/:basename.:extension",
								:default_url => "/images/photo_attachment/missing_thumb.png" }

	validates :logo, :presence=> { :message => "Please upload an image of your logo." }
	validates_attachment_size :logo, :less_than => 2.megabytes, :message => "Please ensure size of the logo image is less than 2MB." 
	validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/,  :message => "Invalid image type for logo." 

end
