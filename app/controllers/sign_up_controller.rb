class SignUpController < ApplicationController
  def index
    @user = User.new
  end

  def create

    @user = User.new(user_params)

    @user.created = Time.now
    @user.modified = Time.now
  	#email = params[:email]
  	#firstname = params[:firstname]
  	#lastname = params[:lastname]
  	password = params[:password]

  	@user.salt = SecureRandom.hex
  	@user.password_hash = generate_hash(password,@user.salt)


  	@user.save

  	redirect_to('/home')

  end

def user_params
      # same as using "params[:subject]", except that it:
      # - raises an error if :subject is not present
      # - allows listed attributes to be mass-assigned
      params.require(:user).permit(:firstname, :lastname, :email, :password)
end

  private

  def generate_hash(password, salt)
  	digest = OpenSSL::Digest::SHA256.new
  	digest.update(password)
  	digest.update(salt)
  	digest.to_s
  end	

end
