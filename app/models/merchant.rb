class Merchant < ActiveRecord::Base
    self.table_name = 'merchant'
    self.primary_key = :merchantid

    has_attached_file :logo, {  styles: {thumb: "75x75#"},
                :path => "#{Rails.root}/public/images/photo_attachment/:merchantid/:style/:basename.:extension",
                :url => "/images/photo_attachment/:path/:style/:basename.:extension",
                :default_url => "/images/photo_attachment/missing_thumb.png",
                :size => { :in => 0..500.kilobytes }
              }


Paperclip.interpolates :path do |attachment, style|
 

   
    return attachment.instance.merchantid
  
end


	validates :merchantname, :presence => { :message => "Please enter the merchant name." },
	                        :length => { :maximum => 50 }
=begin
	validates :checkbalanceurl, :presence => { :message => "Please enter the website to check balance" },
						:url => { :message => "Please enter a valid website.  i.e. http://www.changefindr.com" }
=end
    has_attached_file :logo, {	styles: {thumb: "75x75#"},
								:path => "#{Rails.root}/public/images/photo_attachment/:id/:style/:basename.:extension",
								:url => "/images/photo_attachment/:id/:style/:basename.:extension",
								:default_url => "/images/photo_attachment/missing_thumb.png" }

	validates :logo, :presence=> { :message => "Please upload an image of your logo." }
	validates_attachment_size :logo, :less_than => 2.megabytes, :message => "Please ensure size of the logo image is less than 2MB." 
	validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/,  :message => "Invalid image type for logo." 



  def updatebhnproducts

    curl = Curl::Easy.new(ENV['bhn_url_product_line_preprod'])
    
    r = Random.new
    
    curl.headers['Accept'] = 'application/json'
    curl.headers['Content-Type'] = 'application/json'
    curl.headers["requestorId"] = ENV['bhn_requestorId_preprod'] 
    curl.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
    curl.headers['previousAttempts'] = '0'
    curl.headers['contractId'] = ENV['bhn_contractId_preprod']

    curl.cert = ENV['bhn_cert_preprod']
    curl.cert_key = ENV['bhn_cert_preprod']
    curl.certpassword = ENV['bhn_cert_password_preprod']
    curl.ssl_verify_peer = false
    
    curl.follow_location = true
    curl.ssl_verify_host = false
    curl.ssl_verify_peer = true
    curl.verbose = true

    curl.perform

    results = JSON.parse curl.body_str
    

    #results['currentResults'][0]
#{"productLineId"=>1, "minAcceptedValue"=>20.0, "maxAcceptedValue"=>1000.0, "discount"=>0.58, "name"=>"Abercrombie & Fitch"}

    giftcards = results['currentResults']  # this is the json result to get the gift cards

    #response.headers['date']

    for giftcard in giftcards


      productLineId = giftcard['productLineId'].to_i
     

      merchant = Merchant.where(:productLineId => productLineId).first

      if merchant == nil
        merchant = Merchant.new
      end


      merchant.productLineId = productLineId
      merchant.minAcceptedValue = giftcard['minAcceptedValue'].to_f
      merchant.maxAcceptedValue = giftcard['maxAcceptedValue'].to_f
      merchant.discount = giftcard['discount'].to_f
      merchant.merchantname = giftcard['name']

     
      merchant.merchantid_bak = 9999
      merchant.modified = Time.now
      merchant.save

    end
    

  end

	def updateproducts_bak

		  #url = 'https://sandbox.blackhawknetwork.com/productManagement/v1/productLines?first=0&maximum=10&ascending=true&exactMatch=false&caseSensitive=false'

      request = HTTPI::Request.new('https://sandbox.blackhawknetwork.com/productManagement/v1/productLines?first=0&maximum=500&ascending=true&exactMatch=false&caseSensitive=false')

      request.auth.ssl.cert_key_file = "key.pem"
      request.auth.ssl.cert_file = "key.pem"
      request.headers["requestorId"] = "YGSZRJHZC9KA1VNV62C9ARGSF4"
      request.headers["Content-Type"] =  "application/json; charset=UTF-8"
      request.headers["Accept"] = "application/json; charset=UTF-8"
      request.open_timeout = 31
      request.read_timeout = 31

      response = HTTPI.get request
    
      resultcode = response.code

      results = JSON.parse response.raw_body
      giftcards = results['results']  # this is the json result to get the gift cards

      byebug

      #response.headers['date']

      for giftcard in giftcards


        entityId = giftcard['entityId'].split(/productLine */)[1]
        # remove / from the first characater since it's part of the URL
        entityId[0] = ''

        merchant = Merchant.where(:entityId => entityId).first

        if merchant == nil
          merchant = Merchant.new
        end

        merchant.entityId = entityId
        merchant.entityIdUrl = giftcard['entityId']
        merchant.productLineName = giftcard['productLineName']
        merchant.brandId = giftcard['brandId']
        merchant.merchantname = giftcard['brandName']
        merchant.brandCode = giftcard['brandCode']
        merchant.brandLogoImage = giftcard['brandLogoImage']
        merchant.productLineStatus = giftcard['productLineStatus']
        merchant.accountType = giftcard['accountType']
        merchant.startDate = giftcard['startDate']
        merchant.endDate = giftcard['endDate']
        merchant.locale = giftcard['locale']
        merchant.merchantid_bak = 9999
        merchant.modified = Time.now
        merchant.save

      end


	end

end
