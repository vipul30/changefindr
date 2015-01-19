class SignUpController < ApplicationController
  def index
    @user = User.new
    session[:return_to] = Rails.application.routes.recognize_path(request.referrer)
  end

  def create

    @user = User.new(user_params)

    #found_user = User.where(:email => @user.email).first
    
    #if found_user
    #  flash[:notice] = "Email already exists for this user.  Please either login with this email or use a different email."
    #  render :action => :index
      

    #else
      @user.created = Time.now
      @user.modified = Time.now
      @user.roleid = 2 # everyone starts off as a reguler user
      password = params[:password]

      @user.salt = SecureRandom.hex
      @user.password_hash = generate_hash(password,@user.salt)

      if @user.save
        session[:user_firstname] = @user.firstname
        session[:username] = @user.email
        session[:userid] = @user.userid
        session[:roleid] = @user.roleid
        UserMailer.welcome_email(@user, request.host_with_port).deliver
        flash[:notice] = "Thank you for registering.  You are now logged in."
        redirect_to session[:return_to]
      else
        # If save fails, redisplay the form so user can fix problems
        render('index')
      end
    #end

    

  end

def user_params
      # same as using "params[:subject]", except that it:
      # - raises an error if :subject is not present
      # - allows listed attributes to be mass-assigned
      params.require(:user).permit(:firstname, :lastname, :email, :password)
end

  

end
