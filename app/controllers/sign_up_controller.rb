class SignUpController < ApplicationController
  def index
    @user = User.new
    session[:return_to] ||= request.referer
  end

  def create

    @user = User.new(user_params)

    found_user = User.where(:email => @user.email).first
    
    if found_user
      flash[:notice] = "Email already exists for this user.  Please either login with this email or use a different email."
      render :action => :index
      

    else
      @user.created = Time.now
      @user.modified = Time.now
      password = params[:password]

      @user.salt = SecureRandom.hex
      @user.password_hash = generate_hash(password,@user.salt)

      @user.save

      session[:user_firstname] = user.first_name
      session[:username] = user.email
      redirect_to(:controller => "home", :action => "index")
      
    end

    

  end

def user_params
      # same as using "params[:subject]", except that it:
      # - raises an error if :subject is not present
      # - allows listed attributes to be mass-assigned
      params.require(:user).permit(:firstname, :lastname, :email, :password)
end

  

end
