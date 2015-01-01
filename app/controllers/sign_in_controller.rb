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
	      session[:user_id] = found_user.id
	      session[:username] = found_user.email
	      flash[:notice] = "You are now logged in."
	      redirect_to(:controller => 'home', :action => 'index')
	    else
	      flash[:notice] = "Invalid username/password combination."
	      redirect_to(:action => 'login')
	    end
	end
  end


  




