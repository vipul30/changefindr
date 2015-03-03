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

      
    
      


    end
  

end
