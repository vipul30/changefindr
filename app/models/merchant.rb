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
								:path => "Users/vipul/Sites/changefindr/public/images/photo_attachment/:id/:style/:basename.:extension",
								:url => "/images/photo_attachment/:id/:style/:basename.:extension",
								:default_url => "/images/giftcard-3.jpg",
                :storage => :s3,
                  :s3_credentials => {
                    :bucket => 'changefindr.com',
                    :access_key_id => ACCESS_KEY_ID,
                    :secret_access_key => SECRET_ACCESS_KEY
                  },
                :access_key_id => ACCESS_KEY_ID,
                :secret_access_key => SECRET_ACCESS_KEY,
                :s3_host_name => 's3-us-west-1.amazonaws.com',
                :bucket => 'changefindr.com' }

	#validates :logo, :presence=> { :message => "Please upload an image of your logo." }
	validates_attachment_size :logo, :less_than => 2.megabytes, :message => "Please ensure size of the logo image is less than 2MB." 
	validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/,  :message => "Invalid image type for logo." 


  def httpitest

    r = Random.new
    request = HTTPI::Request.new('https://api.sandbox.blackhawknetwork.com/v2/exchange/supportedProductLines?$first=0&$limit=500&$ascending=true&$sortKey=productLineId')
    request.auth.ssl.cert_key_file = "certs/key_sandbox.pem"
    request.auth.ssl.cert_file = "certs/key_sandbox.pem"
    request.headers["requestorId"] = "YGSZRJHZC9KA1VNV62C9ARGSF4"
    request.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
    request.headers['previousAttempts'] = '0'
    request.headers['contractId'] = '60300003916'
    request.headers["Content-Type"] =  "application/json; charset=UTF-8"
    request.headers["Accept"] = "application/json; charset=UTF-8"
    request.open_timeout = 31
    request.read_timeout = 31
    response = HTTPI.get request
    resultcode = response.code
    results = JSON.parse response.raw_body


  end


  def updatebhnproducts

    curl = Curl::Easy.new(ENV['bhn_url_product_line_preprod'])

    

    i = 0
    while (i <= 2)

      r = Random.new
      
      curl.headers['Accept'] = 'application/json'
      curl.headers['Content-Type'] = 'application/json'
      curl.headers["requestorId"] = ENV['bhn_requestorId_preprod'] 
      curl.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
      curl.headers['previousAttempts'] = '0'
      curl.headers['contractId'] = ENV['bhn_contractId_preprod']

      if Rails.env == "development"

        curl.cert = Rails.root.join(ENV['bhn_cert_preprod']).to_s
        curl.cert_key = Rails.root.join(ENV['bhn_cert_preprod']).to_s

      else
        curl.certtype = "PEM"
        curl.cert = Rails.root.join(ENV['bhn_cert_pem_file_preprod']).to_s #Rails.root.join(ENV['bhn_cert_preprod']).to_s
        curl.cert_key = Rails.root.join(ENV['bhn_cert_pem_file_preprod']).to_s
      end

      curl.certpassword = ENV['bhn_cert_password_preprod']
      curl.ssl_verify_peer = false
      
      curl.follow_location = true
      curl.ssl_verify_host = false
      curl.ssl_verify_peer = false
      curl.verbose = true

=begin
      print "Rails.env= " + Rails.env
      print "\n"
      print curl.post_body
      print "\n"
      print curl.headers
      print "\n"
      print curl.header_str
      print "\n"
      print curl.body_str
      print "\n"
      print 'does cert file exist= ' + curl.cert + ' ' + File.exist?(curl.cert).to_s + "\n"
      print 'does cert pass file exist= ' + curl.cert_key + ' ' + File.exist?(curl.cert_key).to_s + "\n"
      print 'curl.certpassword= ' + ENV['bhn_cert_password_preprod'] 
      print "\n"


      line_num=0
      text=File.open(curl.cert).read
      #text.gsub!(/\r\n?/, "\n")
      text.each_line do |line|
        print "#{line_num += 1} #{line}"
      end

      line_num=0
      text=File.open(curl.cert_key).read
      #text.gsub!(/\r\n?/, "\n")
      text.each_line do |line|
        print "#{line_num += 1} #{line}"
      end
=end

      begin
        curl.perform

      rescue => error

          raise  
      end

      
      results = JSON.parse curl.body_str
      
      if curl.response_code == 200 || curl.response_code == 201
        i = 3
      else

        # timeout error.  retry sending the information for a total of three times
        if curl.response_code == 502 || curl.response_code == 504

          i = i + 1

        else
          # do not make any more calls
          i = 3
        end
      end

      

      #results['currentResults'][0]
      #{"productLineId"=>1, "minAcceptedValue"=>20.0, "maxAcceptedValue"=>1000.0, "discount"=>0.58, "name"=>"Abercrombie & Fitch"}

      giftcards = results['currentResults']  # this is the json result to get the gift cards

      #response.headers['date']

      if giftcards != nil

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



        end # end for loop
      end # end if giftcards != nil
    end # end while loop

    

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
