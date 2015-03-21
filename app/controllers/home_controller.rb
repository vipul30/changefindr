class HomeController < ApplicationController
  def index

  	offset = rand(Charity.count)

  	@causes = Charity.limit(20).order("RANDOM()").where(isapproved: true)

    @merchants = Merchant.where.not(merchantid: 172).limit(20).order("RANDOM()")

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

      url = 'https://sandbox.blackhawknetwork.com/productManagement/v1/productLines?first=0&maximum=10&ascending=true&exactMatch=false&caseSensitive=false'

      request = HTTPI::Request.new('https://sandbox.blackhawknetwork.com/productManagement/v1/productLines?first=0&maximum=500&ascending=true&exactMatch=false&caseSensitive=false')

      request.auth.ssl.cert_key_file = "key.pem"
      request.auth.ssl.cert_file = "key.pem"
      request.headers["requestorId"] = "YGSZRJHZC9KA1VNV62C9ARGSF4"
      request.headers["Content-Type"] =  "application/json; charset=UTF-8"
      request.headers["Accept"] = "application/json; charset=UTF-8"
      request.open_timeout = 29
      request.read_timeout = 29

      response = HTTPI.get request
    
      resultcode = response.code

      results = JSON.parse response.raw_data
      giftcards = results['results']  # this is the json result to get the gift cards

=begin
  (byebug) results['results'][0]
{"entityId"=>"https://sandbox.blackhawknetwork.com/productManagement/v1/productLine/1N8ZBLNAW6SJPNBBL2SMJSC4GH", "productLineName"=>"Sephora", "brandId"=>"KNVD2RCXPDW8M2JAYSRHR2A9R4", "brandName"=>"Sephora", "brandCode"=>"LVMH", "brandLogoImage"=>"https://content.giftcardmall.com/gcmimages/manufacturer/icon/GOWALLET_METADATA/186V2565.0.PNG", "productLineStatus"=>"ACTIVATED", "accountType"=>"GIFT_CARD", "startDate"=>"2013-06-21T22:53:14.000+0000", "endDate"=>"2020-02-01T13:22:54.000+0000", "locale"=>"en_US"}
(byebug) results['results'][0]['entityId']
"https://sandbox.blackhawknetwork.com/productManagement/v1/productLine/1N8ZBLNAW6SJPNBBL2SMJSC4GH"
(byebug) 

=end
  
end


byebug



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
