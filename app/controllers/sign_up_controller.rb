class SignUpController < ApplicationController
  def index
    @user = User.new
  end

  def create

    @user = User.new(user_params)

    @user.created = Time.now
    @user.modified = Time.now
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

  

end
