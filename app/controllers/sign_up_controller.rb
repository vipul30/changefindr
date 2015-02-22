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
      @user.roleid = REGULAR_ROLE # everyone starts off as a reguler user
      password = params[:password]

      @user.salt = SecureRandom.hex
      @user.password_hash = generate_hash(password,@user.salt)

      @user.isVerified = false
      @user.verifysalt = SecureRandom.hex

      @user.firstname = @user.firstname.capitalize
      @user.lastname = @user.lastname.capitalize

      if @user.save

        # check if there is a gift card id in the session.  if so, update the user id for this record
        if session[:newgiftcardid]
          @giftcard = Giftcard.where(:giftcardid => session[:newgiftcardid]).first
          @giftcard.userid = @user.userid
          @giftcard.save
        end

        # check if there are any donations with a matching email and assign it to this user
        # TODO

        UserMailer.welcome_email(@user, request.host_with_port).deliver
        flash[:notice] = "Thank you for registering.  Please confirm your registration by clicking on the link from your email."
        redirect_to session[:return_to]
      else
        # If save fails, redisplay the form so user can fix problems
        render('index')
      end
    #end
  
  end

  def verifyregistration

    @user = User.where(verifysalt: params[:id]).first


    if (@user)

        if (@user.isVerified == true)
          flash[:notice] = "You have already confirmed your registration.  Please login to continue."
          redirect_to(:controller => "home", :action => "index")
          
        end

        @user.modified = Time.now
        @user.lastlogin = Time.now
        @user.verifysalt = nil
        @user.isVerified = true

        if @user.save
          session[:user_firstname] = @user.firstname
          session[:username] = @user.email
          session[:userid] = @user.userid
          session[:roleid] = @user.roleid
          flash[:notice] = "Thank you for confirming your registration.  You are now logged in."
          redirect_to(:controller => "home", :action => "index")
          
        end

    else
      flash[:notice] = "Invalid registration link.  Please try again or contact support for assistance."
      redirect_to(:controller => "home", :action => "index")
      
    end

  end  

  def resendverifylink
    flash[:notice] = nil
  end

  def resendverifylinksubmit


    email = params[:email]
    @user = User.where(email: email).first


    if (@user)

      UserMailer.welcome_email(@user, request.host_with_port).deliver
      flash[:notice] = "Registration link has been resent."
      redirect_to(:controller => "home", :action => "index")

    else

      flash[:notice] = "Email not found.  Please register in order to login."
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
