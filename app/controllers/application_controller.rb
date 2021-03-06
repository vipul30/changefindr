class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
protect_from_forgery
include ActionView::Helpers::NumberHelper
require 'aws-sdk'

  def generate_hash(password, salt)
  	digest = OpenSSL::Digest::SHA256.new
  	digest.update(password)
  	digest.update(salt)
  	digest.to_s

  end	

  def verify_password(password, salt, password_hash)
  	password_hash == generate_hash(password, salt)
  end

  def generate_hash(password, salt)
    digest = OpenSSL::Digest::SHA256.new
    digest.update(password)
    digest.update(salt)
    digest.to_s

  end 

  
  def decryptdata(encrypted, key, iv)
    decipher = OpenSSL::Cipher::AES.new(128, :CBC)
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv

    plain = decipher.update(encrypted) + decipher.final

  end

  def initializelogin(user)

      
    
      session[:usergiftcardscount] = Giftcard.where(:isdeleted => false)
                      .where(:userid => user.userid)
                      .count
      
      if user.roleid == ADMIN_ROLE
        session[:donationscount] = Donation.all.count
      else

      session[:donationscount] = Donation.where(:userid => user.userid)
                        .count


      end

      session[:account_id] = user.account_id


  end

  def getcardbalance(cardnumber, pinnumber, productlineid)


      i = 0
      bhnquote = Bhnquote.new

      while (i <= 2)

        r = Random.new

        params = { 

          
          :contractId => ENV['bhn_contractId'],
          :requestId => r.rand(10...5000).to_s + ENV['bhn_requestorId'],
          :previousAttempts => i,
          :requestorId => ENV['bhn_requestorId'],
          
          :card => {:cardNumber => cardnumber, :pinNumber => pinnumber, :productLineId => productlineid} 
          

        }

        curl = Curl::Easy.new(ENV['bhn_url_quote'])
        
        curl.headers['Accept'] = 'application/json'
        curl.headers['Content-Type'] = 'application/json'
        curl.headers["requestorId"] = ENV['bhn_requestorId']
        curl.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
        curl.headers['previousAttempts'] = '0'
        curl.headers['contractId'] = ENV['bhn_contractId']

      if Rails.env == "development" || Rails.env == "test"

        curl.cert = Rails.root.join(ENV['bhn_cert']).to_s
        curl.cert_key = Rails.root.join(ENV['bhn_cert']).to_s

      else
        curl.certtype = "PEM"
        curl.cert = Rails.root.join(ENV['bhn_cert_pem_file']).to_s #Rails.root.join(ENV['bhn_cert_prod']).to_s
        curl.cert_key = Rails.root.join(ENV['bhn_cert_pem_file']).to_s
      end



        curl.certpassword = ENV['bhn_cert_password']
        
        curl.follow_location = true
        curl.ssl_verify_host = false
        curl.ssl_verify_peer = true
        curl.verbose = true
        curl.timeout = 31
        
        byebug

        begin
          result = curl.http_post(params.to_json) {
            [http]
              response_bhn = http.headers
              
          }

        rescue => error

          byebug

          raise  
        end

        # testing
        #bhnquote = Bhnquote.new
        #bhnquote.created = Time.now
        #bhnquote.errorMessage = curl.body_str
        #bhnquote.giftcardid = nil
        #bhnquote.save
        # testing


        bhnresponse = JSON.parse curl.body_str

        bhnquote = Bhnquote.new
        bhnquote.created = Time.now
        bhnquote.responsecode = curl.response_code.to_s

        

        if curl.response_code == 200 || curl.response_code == 201 # || bhnresponse['errors'][0]['errorCode'] == 'exchange.card.value.out.of.range'

            # store all information in database and return object
            bhnquote.responseTimestamp = Time.parse bhnresponse['responseTimestamp']
            bhnquote.actualCardValue = bhnresponse['actualCardValue'].to_f
            bhnquote.exchangeCardValue = bhnresponse['exchangeCardValue'].to_f
            bhnquote.transactionId = bhnresponse['transactionId']
            i = 3

        elsif bhnresponse['errors'][0]['errorCode'] == 'exchange.card.value.out.of.range'

           #bhnquote = bhnbalancecheck(cardnumber, pinnumber, productlineid)
           bhnquote.responseTimestamp = Time.now
           bhnquote.actualCardValue = bhnresponse['additionalInfo']['actualCardValue'].to_f
           bhnquote.errorCode = bhnresponse['errors'][0]['errorCode']
           bhnquote.errorMessage = bhnresponse['errors'][0]['message']
           bhnquote.exchangeCardValue = 0.0
           i = 3
          
        else

          
            bhnquote.errorCode = bhnresponse['errors'][0]['errorCode']
            bhnquote.errorMessage = bhnresponse['errors'][0]['message']

            emailmessage = bhnquote.errorCode + ' ' + bhnquote.errorMessage + ' ' + curl.body_str + ' ' + curl.header_str + ' ' + curl.post_body.to_s

            BhnMailer.bhn_error_email(emailmessage)  

            # timeout error.  retry sending the information for a total of three times
            if curl.response_code == 502 || curl.response_code == 504

              i = i + 1

            else
              # do not make any more calls
              i = 3

            end


        end

      end # end while loop
        
      return bhnquote


  end


  def bhnbalancecheck(cardnumber, pinnumber, productlineid)

    # cross reference bhn table to get the product line id
    bhnproduct = Bhnmerchantcrossref.where(:CardPoolMerchantID => productlineid.to_s).first



    if bhnproduct == nil 
      bhnquote = Bhnquote.new
      bhnquote.created = Time.now
      bhnquote.responsecode = '400'
      bhnquote.errorCode = 'exchange.card.value.out.of.range'
      bhnquote.errorMessage = 'Unable to get card balance.  Please contact info@changefindr.com to get balance.'
      bhnquote.responseTimestamp = Time.now
      bhnquote.actualCardValue = 0.0
      bhnquote.exchangeCardValue = 0.0
      bhnquote.transactionId = '0'
      return bhnquote
    end


    # https://developer.blackhawknetwork.com/documentation/apiReference/Service+-+Account_Processing/Operation+-+Verify_Account

    # testing
    #cardnumber = '9877890000006666'
    #bhnproduct.ProductLineID = 'MWY16JB102NGRL7DZKCJKCT9AC'
    #pinnumber = '1234'

    url = 'https://api.blackhawknetwork.com/accountProcessing/v1/verifyAccount?accountNumber=' + cardnumber.to_s + '&productLineId=' + bhnproduct.ProductLineID.to_s + '&pin=' + pinnumber.to_s + '&accountType=GIFT_CARD'

    #url = URI(url)

    curl = Curl::Easy.new(url)

    r = Random.new
    
    curl.headers['Accept'] = 'application/json'
    curl.headers['Content-Type'] = 'application/json'
    curl.headers["requestorId"] = ENV['bhn_requestorId'] 
    curl.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
    curl.headers['previousAttempts'] = '0'
    curl.headers['contractId'] = ENV['bhn_contractId']

    if Rails.env == "development" || Rails.env == "test"

      curl.cert = Rails.root.join(ENV['bhn_cert']).to_s
      curl.cert_key = Rails.root.join(ENV['bhn_cert']).to_s

    else
      curl.certtype = "PEM"
      curl.cert = Rails.root.join(ENV['bhn_cert_pem_file']).to_s #Rails.root.join(ENV['bhn_cert_prod']).to_s
      curl.cert_key = Rails.root.join(ENV['bhn_cert_pem_file']).to_s
    end

    curl.certpassword = ENV['bhn_cert_password']
    curl.ssl_verify_peer = false
    
    curl.follow_location = true
    curl.ssl_verify_host = false
    curl.ssl_verify_peer = false
    curl.verbose = true
    curl.timeout = 31


    begin
      curl.perform

    rescue => error

      byebug
      bhnquote = Bhnquote.new
      bhnquote.created = Time.now
      bhnquote.responsecode = curl.response_code.to_s
      bhnquote.errorCode = '502'
      bhnquote.errorMessage = 'com.bhn.general.service.error'
      return bhnquote

    end

    

    bhnresponse = JSON.parse curl.body_str



    bhnquote = Bhnquote.new
    bhnquote.created = Time.now
    bhnquote.responsecode = curl.response_code.to_s

    

    if curl.response_code == 200 || curl.response_code == 201

        # store all information in database and return object
        bhnquote.responseTimestamp = Time.parse bhnresponse['updatedTimestamp']
        bhnquote.actualCardValue = bhnresponse['balance'].to_f
        bhnquote.exchangeCardValue = 0.0
        bhnquote.transactionId = bhnresponse['entityId']
        
      
    else

        bhnquote.errorCode = bhnresponse['errorCode']
        bhnquote.errorMessage = bhnresponse['message']

        emailmessage = bhnquote.errorCode + ' ' + bhnquote.errorMessage + ' ' + curl.body_str + ' ' + curl.header_str + ' ' + curl.post_body.to_s

        BhnMailer.bhn_error_email(emailmessage)  

    end



    return bhnquote
      
  end


  def bhnacquirecard(donation)


    i = 0
    bhnacquire = Bhnacquire.new

    while (i <= 2)

        r = Random.new
        

        if donation.userid == nil
          name = donation.firstname + ' ' + donation.lastname
          email = donation.email
        else
          user = User.where(:userid => donation.userid).first

          name = user.firstname + ' ' + user.lastname
          email = user.email

        end

        salt = BHN_SALT # change salt to static SecureRandom.hex
        customerId = generate_hash(email,salt)

         merchant = Merchant.where(:merchantid => donation.giftcard.merchantid).first

        params = { 

          
          :contractId => ENV['bhn_contractId'],
          :requestId => r.rand(10...5000).to_s + ENV['bhn_requestorId'],
          :previousAttempts => 0,
          :requestorId => ENV['bhn_requestorId'],

          :card => {:cardNumber => donation.giftcard.cardnumber, :pinNumber => donation.giftcard.pin, :productLineId => merchant.productLineId}, 

          :cardHolder => {
               :name =>  name,
               :emailAddress =>  email ,
               #:phoneNumber =>  "714-809-0811" ,
               :customerId  =>  customerId

            }

        }

        curl = Curl::Easy.new(ENV['bhn_url_acquire'])
        
        curl.headers['Accept'] = 'application/json'
        curl.headers['Content-Type'] = 'application/json'
        curl.headers["requestorId"] = ENV['bhn_requestorId']
        originalRequestId = r.rand(10...5000).to_s + Time.now.to_s
        curl.headers["requestId"] = originalRequestId
        curl.headers['previousAttempts'] = i.to_s
        curl.headers['contractId'] = ENV['bhn_contractId']


        if Rails.env == "development" || Rails.env == "test"

            curl.cert = Rails.root.join(ENV['bhn_cert']).to_s
            curl.cert_key = Rails.root.join(ENV['bhn_cert']).to_s

        else
            curl.certtype = "PEM"
            curl.cert = Rails.root.join(ENV['bhn_cert_pem_file']).to_s #Rails.root.join(ENV['bhn_cert_prod']).to_s
            curl.cert_key = Rails.root.join(ENV['bhn_cert_pem_file']).to_s
        end

        #curl.cert = ENV['bhn_cert_prod']
        #curl.cert_key = ENV['bhn_cert_pass_file_prod']
        curl.certpassword = ENV['bhn_cert_password']
        curl.ssl_verify_peer = false
        
        curl.follow_location = true
        curl.ssl_verify_host = false
        curl.ssl_verify_peer = true
        curl.verbose = true
        curl.timeout = 31
        

        begin
          result = curl.http_post(params.to_json) {
            [http]
              response_bhn = http.headers
              
          }

        rescue => error
          
        end

        bhnresponse = JSON.parse curl.body_str

        

        bhnacquire = Bhnacquire.new
        bhnacquire.donationid = 
        bhnacquire.created = Time.now
        bhnacquire.responsecode = curl.response_code.to_s
        bhnacquire.donationid = donation.donationid
        bhnacquire.customerId = customerId


        

        if curl.response_code == 200 || curl.response_code == 201

            # store all information in database and return object
            bhnacquire.responseTimestamp = Time.parse bhnresponse['responseTimestamp']
            bhnacquire.actualCardValue = bhnresponse['actualCardValue'].to_f
            bhnacquire.exchangeCardValue = bhnresponse['exchangeCardValue'].to_f
            bhnacquire.transactionId = bhnresponse['transactionId']
            bhnacquire.isCompleted = bhnresponse['isCompleted']
            i = 3


        else

            bhnacquire.errorCode = bhnresponse['errors'][0]['errorCode']
            bhnacquire.errorMessage = bhnresponse['errors'][0]['message']

            emailmessage = bhnacquire.errorCode + ' ' + bhnacquire.errorMessage + ' ' + curl.body_str + ' ' + curl.header_str + ' ' + curl.post_body.to_s


            BhnMailer.bhn_error_email(emailmessage)

            # timeout error.  retry sending the information for a total of three times
            if curl.response_code == 502 || curl.response_code == 504

              # send info to acquire card reversal
              bhnacquirereversal(originalRequestId)

              i = i + 1

            else
              # do not make any more calls
              i = 3

            end

        end # end if curl response code is not 200 or 201

    end # end while loop


    return bhnacquire


  end

  def bhnacquirereversal(originalRequestId)

        r = Random.new

        curl = Curl::Easy.new(ENV['bhn_url_acquire_reversal'])
        
        params = { 
 
          :originalRequestId => originalRequestId

        }

        curl.headers['Accept'] = 'application/json'
        curl.headers['Content-Type'] = 'application/json'
        curl.headers["requestorId"] = ENV['bhn_requestorId']
        curl.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
        curl.headers["originalRequestId"] = originalRequestId
        curl.headers['previousAttempts'] = '0'
        curl.headers['contractId'] = ENV['bhn_contractId']

        if Rails.env == "development" || Rails.env == "test"

            curl.cert = Rails.root.join(ENV['bhn_cert']).to_s
            curl.cert_key = Rails.root.join(ENV['bhn_cert']).to_s

        else
            curl.certtype = "PEM"
            curl.cert = Rails.root.join(ENV['bhn_cert_pem_file']).to_s #Rails.root.join(ENV['bhn_cert_prod']).to_s
            curl.cert_key = Rails.root.join(ENV['bhn_cert_pem_file']).to_s
        end

        
        curl.certpassword = ENV['bhn_cert_password']
        curl.ssl_verify_peer = false
        
        curl.follow_location = true
        curl.ssl_verify_host = false
        curl.ssl_verify_peer = true
        curl.verbose = true
        curl.timeout = 31
        

        begin
          result = curl.http_post(params.to_json) {
            [http]
              response_bhn = http.headers
              
          }

        rescue => error
      
        end

        
  end

  

end
