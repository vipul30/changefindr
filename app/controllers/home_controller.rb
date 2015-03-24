class HomeController < ApplicationController
  def index

  	offset = rand(Charity.count)

  	@causes = Charity.limit(20).order("RANDOM()").where(isapproved: true)

    @merchants = Merchant.where.not(merchantid_bak: 172)
                         .where.not(merchantid_bak: 9999)
                         .limit(20).order("RANDOM()")

    #@merchants = Merchant.where(:productLineStatus => 'ACTIVATED')
                         #.where(:accountType => 'GIFT_CARD')

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

      response = RestClient::Resource.new(
      'https://sandbox.blackhawknetwork.com/v2/exchange/quote',
      :ssl_ca_file      =>  "key.pem",
      :verify_ssl       =>  OpenSSL::SSL::VERIFY_PEER,
      :open_timeout     => 31,
      :read_timeout     => 31,
      :body        => {

            "card" => {
              
                   "cardNumber" => "123456789" ,
                   "pinNumber" => "1513" ,
                   "productLineId"  =>  "16"
              
                  },
                  "contractId" => "12345678912",
                  "previousAttempts" => "0",
                  "requestorId" => "YGSZRJHZC9KA1VNV62C9ARGSF4"
            }
      
     ).get

     byebug

    
    request = HTTPI::Request.new('https://sandbox.blackhawknetwork.com/v2/exchange/quote')
    request.auth.ssl.cert_key_file = "key.pem"
    request.auth.ssl.cert_file = "key.pem"
    #request.headers["contractId"] = "12345678912"
    request.headers["requestorId"] = "YGSZRJHZC9KA1VNV62C9ARGSF4"
    #request.headers["previousAttempts"] =  "0"
    request.headers["Accept"] = "application/json; charset=UTF-8"
    request.open_timeout = 31
    request.read_timeout = 31
    card = {
        
             "cardNumber" => "123456789" ,
             "pinNumber" => "1513" ,
             "productLineId"  =>  "16"
        
    }.to_json

    #request.headers["card"] = card

    request.body = {
      "card" => card,
      "contractId" => "12345678912",
      "previousAttempts" => "0",
      "requestorId" => "YGSZRJHZC9KA1VNV62C9ARGSF4"


    }.to_json

    response = HTTPI.post request

    byebug
  
    resultcode = response.code

    results = JSON.parse response.raw_body


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
