class SignInController < ApplicationController
  def index
  	begin
  		session[:return_to] = Rails.application.routes.recognize_path(request.referrer)
  	rescue
  		session[:return_to] = '/home/index'
  	end

  end

  def login


  	email = params[:email]
  	password = params[:password]

	if params[:email].present? && params[:password].present?
	      found_user = User.where(:email => params[:email]).first
	      if found_user
	        authorized_user = verify_password(params[:password], found_user.salt, found_user.password_hash)

	        found_user.lastlogin = Time.now
	        found_user.save
	      end
	    end
	    if authorized_user

	      	# check if there is a gift card id in the session.  if so, update the user id for this record
			if session[:newgiftcardid]
				@giftcard = Giftcard.where(:giftcardid => session[:newgiftcardid]).first
				@giftcard.userid = found_user.userid
				@giftcard.save
			end

	      # check if user has verified the email address by clicking on the registration verify link
	      verfieduser = User.where(:isVerified => true).first

	      if (!verfieduser)
	      	# todo: resend verification link
	      	flash[:notice] = "Please verify your registration by clicking on the link from the email sent. Click #{view_context.link_to('HERE', '/sign_up/resendverifylink')} to resend email.".html_safe
	      	render('index')
	      	return
	      end

	      # mark user as logged in
	      session[:user_firstname] = found_user.firstname
	      session[:username] = found_user.email
	      session[:userid] = found_user.userid
		  session[:roleid] = found_user.roleid
		  initializelogin(found_user)

		  if (Giftcard.where(:userid == found_user.userid).count > 0)

	      	flash[:notice] = "You are logged in.  Click #{view_context.link_to('HERE', '/giftcard/index')} to view your gift card balance(s).".html_safe
	      
	      else

	      	flash[:notice] = "You are logged in."

	      end


		    if session[:partnersite] == true

	      		redirect_to(:controller => 'donate', :action => 'new', 
	      					:charityid => session[:partnercharityid], :returnurl => session[:returnurl],
	      					:partnersite => 'true')
	      		return

	      	else
		      redirect_to session[:return_to]
		      return
	  		end
	    else
	      flash[:notice] = "Invalid username/password combination."
	      render('index')
	      return
	    end
	end

	def login_facebook

		auth = env["omniauth.auth"]

		user = User.where(provideruid: auth.uid).first

		newuser = false

		if (!user)
			newuser = true
			user = User.new
			user.roleid = REGULAR_ROLE # everyone starts off as a reguler user
		end

		begin
		user.facebookresponse = auth.to_s
		rescue
		end

		user.firstname = auth.info.first_name
		user.lastname = auth.info.last_name
		user.provider = auth.provider
		user.email = auth.info.email
		user.location = auth.info.location
		user.provideruid = auth.uid


		begin

			user.imageurl = auth.info.image + '?type=large'
		rescue
		end

		user.gender = auth.extra.raw_info.gender

		begin
		user.birthday = Date.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y")
		rescue
		end

		user.providerurl = auth.extra.raw_info.link
		user.locale = auth.extra.raw_info.locale
		user.providerusername = auth.extra.raw_info.username
		user.timezone = auth.extra.raw_info.timezone
		user.created = Time.now
		user.modified = Time.now
		user.lastlogin = Time.now
		
		user.isVerified = true # by default user is verified as having a valid email from facebook
		
	
		if user.save

			if newuser
		    	flash[:notice] = "Thank you for registering.  You are now logged in."
		    	UserMailer.welcome_email(user, request.host_with_port).deliver
		    end
		    	#redirect_to session[:return_to]
	    		#return
	    	
		else
		  	
		  	# If save fails, redisplay the form so user can fix problems
		  	flash[:notice] = "A user with the same Facebook email address already exists."
			redirect_to session[:return_to]
			return
		end
		

		# check if there is a gift card id in the session.  if so, update the user id for this record
		if session[:newgiftcardid]
			@giftcard = Giftcard.where(:giftcardid => session[:newgiftcardid]).first
			@giftcard.userid = user.userid
			@giftcard.save
		end

	 	session[:user_firstname] = user.firstname
		session[:username] = user.email
		session[:userid] = user.userid
		session[:roleid] = user.roleid
		initializelogin(user)

		returnto = session[:return_to]

		if (Giftcard.where(:userid == user.userid).count > 0)

	      	flash[:notice] = "You are logged in.  Click #{view_context.link_to('HERE', '/giftcard/index')} to view your gift card balance(s).".html_safe
	      
	    else

	      	flash[:notice] = "You are logged in."

	    end

	    if session[:partnersite] == true

      		redirect_to(:controller => 'donate', :action => 'new', 
      					:charityid => session[:partnercharityid], :returnurl => session[:returnurl],
      					:partnersite => 'true')

	    elsif returnto["controller"] == 'giftcard' || returnto["controller"] == 'sign_up' || returnto["controller"] == 'sign_in'

	    	redirect_to(:controller => "home", :action => "index")

	    else

			redirect_to returnto
		end
		
		return

	end

	def logout
	    
	    reset_session

	    flash[:notice] = "Logged out"
	    redirect_to(:controller => "home", :action => "index")
  	end

  	


  def recoverpassword
    flash[:notice] = nil
  end

  def recoverpasswordemail


    email = params[:email]
    @user = User.where(email: email).first


    if (@user)

      @user.passwordresetsalt = SecureRandom.hex

      @user.save

      UserMailer.resetpassword_email(@user, request.host_with_port).deliver
      flash[:notice] = "Reset password link has been sent."
      redirect_to(:controller => "home", :action => "index")

    else

      flash[:notice] = "Email not found.  Please register in order to login."
      redirect_to(:controller => "home", :action => "index")
    end

  end


  def resetpassword

	@user = User.where(passwordresetsalt: params[:id]).first


    if (@user)

        return

    else
      flash[:notice] = "Invalid reset password link.  Please try again or contact support for assistance."
      redirect_to(:controller => "home", :action => "index")
      
    end

  end

  def resetpasswordsubmit

	  @user = User.where(email: params[:email]).first


	  password = params[:password]

	  @user.modified = Time.now
      @user.salt = SecureRandom.hex
      @user.password_hash = generate_hash(password,@user.salt)
      @user.passwordresetsalt = nil

      if (@user.save)

		  session[:user_firstname] = @user.firstname
          session[:username] = @user.email
          session[:userid] = @user.userid
          session[:roleid] = @user.roleid
          flash[:notice] = "Password has been reset.  You are now logged in."
          redirect_to(:controller => "home", :action => "index")

      else
      	  flash[:notice] = "There was an error resetting your password.  Please try again."
          redirect_to(:controller => "home", :action => "index")

      end



  end


  end


  




