class SignInController < ApplicationController
  def index
  end

  def login


  	email = params[:email]
  	password = params[:password]

	if params[:email].present? && params[:password].present?
	      found_user = User.where(:email => params[:email]).first
	      if found_user
	        authorized_user = verify_password(params[:password], found_user.salt, found_user.password_hash)
	      end
	    end
	    if authorized_user
	      # mark user as logged in
	      session[:user_firstname] = found_user.firstname
	      session[:username] = found_user.email
	      flash[:notice] = "You are logged in."
	      redirect_to(:controller => 'home', :action => 'index')
	      return
	    else
	      flash[:notice] = "Invalid username/password combination."
	      redirect_to(:action => 'index')
	      return
	    end
	end

	def login_facebook


		auth = env["omniauth.auth"]

		# check if this user already exists with a regular login
		#found_user = User.where(:email => auth.info.email).first
    
    	#if found_user
      	#	flash[:notice] = "Email already exists for this user.  Please either login with this email or use a different email."
      	#	redirect_to  :controller => :sign_up, :action => :index
    	#else

		user = User.where(provideruid: auth.uid).first


		if (!user)
		  user = User.new	
	      user.firstname = auth.info.first_name
		  user.lastname = auth.info.last_name
		  user.provider = auth.provider
		  user.email = auth.info.email
		  user.location = auth.info.location
		  user.provideruid = auth.uid
		  #user.image = auth.info.image
		  user.gender = auth.extra.raw_info.gender
		  user.birthday = Date.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y")
		  user.providerurl = auth.extra.raw_info.link
		  user.locale = auth.extra.raw_info.locale
		  user.providerusername = auth.extra.raw_info.username
		  user.timezone = auth.extra.raw_info.timezone
		  user.created = Time.now
     	  user.modified = Time.now
      	  
      	  if user.save
      	  	session[:user_firstname] = user.firstname
			session[:username] = user.email
		    flash[:notice] = "Thank you for registering.  You are now logged in."
		    redirect_to(:controller => "home", :action => "index")
		    return
      	  else
      	  	
      	  	# If save fails, redisplay the form so user can fix problems
      	  	flash[:notice] = "A user with the same Facebook email already exists."
        	redirect_to(:controller => "sign_up", :action => "index")
        	#render :controller => 'sign_up', :action => 'index'
        	return
      	  end

		end
	 
	 	session[:user_firstname] = user.firstname
		session[:username] = user.email
		redirect_to(:controller => "home", :action => "index")
		return

	end

	def logout
	    # mark user as logged out
	    session[:user_firstname] = nil
	    session[:username] = nil
	    flash[:notice] = "Logged out"
	    redirect_to(:controller => "home", :action => "index")
  end

  end


  




