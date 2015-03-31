class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
protect_from_forgery


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


  end

  def getcardbalance(cardnumber, pinnumber, productlineid)

    r = Random.new
    

    params = { 

      
      :contractId => ENV['bhn_contractId_preprod'],
      :requestId => r.rand(10...5000).to_s + ENV['bhn_requestorId_preprod'],
      :previousAttempts => 0,
      :requestorId => ENV['bhn_requestorId_preprod'],
      
      :card => {:cardNumber => cardnumber, :pinNumber => pinnumber, :productLineId => productlineid} 
      

    }

    curl = Curl::Easy.new(ENV['bhn_url_quote_preprod'])
    
    
    curl.headers['Accept'] = 'application/json'
    curl.headers['Content-Type'] = 'application/json'
    curl.headers["requestorId"] = ENV['bhn_requestorId_preprod']
    curl.headers["requestId"] = r.rand(10...5000).to_s + Time.now.to_s
    curl.headers['previousAttempts'] = '0'
    curl.headers['contractId'] = ENV['bhn_contractId_preprod']

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

    bhnresponse = JSON.parse curl.body_str
    #byebug


  end

  

end
