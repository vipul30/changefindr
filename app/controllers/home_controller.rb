class HomeController < ApplicationController
  def index

    #Merchant.new.updatebhnproducts

    #bhnquote = Bhnquote.new
    #bhnquote = getcardbalance('123456789', '1234', '16')
    #byebug
    #testbhnwebservice4

  	offset = rand(Charity.count)

  	@causes = Charity.limit(20).order("RANDOM()").where(isapproved: true)

    #@merchants = Merchant.where.not(merchantid_bak: 172)
    #                     .where.not(merchantid_bak: 9999)
    #                     .limit(20).order("RANDOM()")

    @merchants = Merchant.where(merchantid_bak: 9999)
                         .limit(20).order("RANDOM()")

                         

  	@userhost = request.host_with_port

    if session[:usergiftcardscount]
    
      @usergiftcards = Giftcard.where(:isdeleted => false)
                        .where(:userid => session[:userid])
                        .order(modified: :desc)
                        .limit(2)

      @usergiftcardscount = Giftcard.where(:isdeleted => false)
                        .where(:userid => session[:userid])
                        .count
    end


    if @usergiftcards
  	   @giftcardstats = Giftcardstat.limit(3).order("RANDOM()")
    end


    

  end

  def testbhnwebservice

    response = RestClient.post 'https://api.sandbox.blackhawknetwork.com/v2/exchange/quote', 
              :card => { :cardNumber => '123456789', :pinNumber => "1513", :productLineId  =>  "16" },
              :contractId => '12345678912',
              :previousAttempts => '0',
              :requestorId => 'YGSZRJHZC9KA1VNV62C9ARGSF4',
              
              :ssl_client_key => "key.pem",
              :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER,
              :open_timeout     => 31,
              :read_timeout     => 31,
              :content_type =>'application/json; charset=UTF-8',
              :accept => 'application/json; charset=UTF-8',
              :headers => {
                :content_type =>'application/json',               
                :accept => 'application/json',
                :requestorId => 'YGSZRJHZC9KA1VNV62C9ARGSF4',
                :contractId =>  '1234567891011'
                }  

   

    byebug

  end

  

  def testbhnwebservice2


    uri = URI.parse("https://api.sandbox.blackhawknetwork.com/v2/exchange/quote")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    raw = File.read "key.pem" # DER- or PEM-encoded
    certificate = OpenSSL::X509::Certificate.new raw
    http.cert = certificate
    http.read_timeout = 10
    http.open_timeout = 10
    request = Net::HTTP::Post.new(uri)
    request.add_field('Content-Type', 'application/json')
    request.add_field('Accept',' application/json; charset=UTF-8')
    request.add_field('requestorId','YGSZRJHZC9KA1VNV62C9ARGSF4')
    request.body = {"card"=> {
                      "cardNumber" => "123456789" ,
                       "pinNumber" => "1513" ,
                       "productLineId"  =>  "16"
                     },                                        
                     "contractId"=>"1234567891011","requestorId"=>"YGSZRJHZC9KA1VNV62C9ARGSF4","previousAttempts"=>"0"
                   }

byebug
    response = http.request(request)

    byebug

  end

  def testbhnwebservice3

    request = HTTPI::Request.new('https://sandbox.blackhawknetwork.com/v2/exchange/quote')
    #request.auth.ssl.cert_key_file = "key.pem"
    request.auth.ssl.cert_key_file = 'cert.p12'
    request.auth.ssl.cert_key_password = '3J3XMFN2'
    request.headers["contractId"] = "60300003916"
    request.headers["requestorId"] = "YGSZRJHZC9KA1VNV62C9ARGSF4"
    request.headers["previousAttempts"] =  "0"
    request.headers["Accept"] = "application/json; charset=UTF-8"
    request.open_timeout = 31
    request.read_timeout = 31
    card = {
        
             "cardNumber" => "123456789" ,
             "pinNumber" => "1513" ,
             "productLineId"  =>  "16"
        
    }.to_json

    request.headers["card"] = card
    
    begin
      response = HTTPI.post request
      resultcode = response.code

      results = JSON.parse response.raw_body
    rescue => error

      byebug
    end

    
   

byebug

  end

  def testbhnwebservice4

    r = Random.new
    

    params = { 

      
      :contractId => ENV['bhn_contractId_preprod'],
      :requestId => r.rand(10...5000).to_s + ENV['bhn_requestorId_preprod'],
      :previousAttempts => 0,
      :requestorId => ENV['bhn_requestorId_preprod'],
      
      :card => {:cardNumber => "1234567", :pinNumber => "153", :productLineId => "16"} 
      

    }

    curl = Curl::Easy.new(ENV['bhn_url_quote_preprod'])
    
    
    curl.headers['Accept'] = 'application/json'
    curl.headers['Content-Type'] = 'application/json'
    curl.headers["requestorId"] = ENV['bhn_requestorId_preprod']
    curl.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
    curl.headers['previousAttempts'] = '0'
    curl.headers['contractId'] = ENV['']

    curl.cert = ENV['bhn_cert_preprod']
    curl.cert_key = ENV['bhn_cert_pass_file_preprod']
    curl.certpassword = ENV['bhn_cert_password_preprod']
    curl.ssl_verify_peer = false
    
    curl.follow_location = true
    curl.ssl_verify_host = false
    curl.ssl_verify_peer = true
    curl.verbose = true
    

    begin
      result = curl.http_post(params.to_json) {
        [http]
          response_bhn = http.headers
          
      }
      
    rescue => error
      byebug
    end

    bhnresonse = curl.body_str
    byebug


  end

  def testbhnwebservice5

    request = HTTPI::Request.new('https://sandbox.blackhawknetwork.com/v2/exchange/quote')
    #request.auth.ssl.cert_key_file = "key.pem"
    request.auth.ssl.cert_file = "key.pem"
    

    request.body = 
    {
      'Content-Type' => 'application/json',
      'contractId' => '60300003916',
      'requestId' => 'YGSZRJHZC9KA1VNV62C9ARGSF4',
      'previousAttempts' => '0',
      
           'card'  => {
               'cardNumber' => '123456789',
               'pinNumber' => '1513',
               'productLineId'  =>  '16'
           }
      
    }.to_json

    
    
    begin
      response = HTTPI.post request
      resultcode = response.code

      results = JSON.parse response.raw_body
    rescue => error

      byebug
    end

    
   

byebug

  end


   def bhnacquire1

    request = HTTPI::Request.new('https://sandbox.blackhawknetwork.com/v2/exchange/acquire')
    #request.auth.ssl.cert_key_file = "key.pem"
    request.auth.ssl.cert_file = "key.pem"
    request.headers["contractId"] = "60300003916"
    request.headers["requestorId"] = "YGSZRJHZC9KA1VNV62C9ARGSF4"
    request.headers["Content-Type"] =  "application/json"
    


    request.headers["Accept"] = "application/json; charset=UTF-8"
    request.open_timeout = 31
    request.read_timeout = 31
    card = {
        
             "cardNumber" => "123456789" ,
             "pinNumber" => "1513" ,
             "productLineId"  =>  "16"
        
    }.to_json

    request.headers["card"] = card
    
    begin
      response = HTTPI.post request
      resultcode = response.code

      results = JSON.parse response.raw_body
    rescue => error

      byebug
    end

    
   

byebug

  end


  def getbhnproducts

      # replaced by Merchant.updateproducts rake schedule command
      
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


  def newslettersignup

    @nletter = Newsletter.new
    @nletter.email = params[:email]
    @nletter.created = Time.now
    @nletter.modified = Time.now
    @nletter.isactive = true
    @message = ''


    if @nletter.email == nil

      @message = "Please enter an email address."

    # check if active email already exists
    elsif Newsletter.where(:email => @nletter.email)
                  .where(:isactive => true).first


      @message = "You are already receiving treats from us."
      
    elsif @nletter.save

      @message = "Thank you for adding your email to our newsletter"
      
    else
      
      if @nletters != nil
        if @nletters.errors
          @nletters.errors.messages.values.each do |msg|
            @message = msg
            break
          end
        else  
          @message = "Invalid email."
        end
      else
        @message = "Invalid email."
      end

    end


    render :json => @message.to_json

    #redirect_to(:back) 
    
  end

  def mailerlayout
  	
  	render ('user_mailer/mailerlayout')
  end

  def error
    flash[:notice] = "There was an error processing your request.  An email has been sent to the administrator."
    redirect_to(:controller => "home", :action => "index")
  end

end
