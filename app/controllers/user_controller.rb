class UserController < ApplicationController
  
  def index

    if session[:roleid] == ADMIN_ROLE
      @users = User.order('lastname ASC').page(params[:page]).per_page(9)
    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return
    end

  end

  def delete
  end

  def edit

    if session[:roleid] == ADMIN_ROLE || session[:userid] == params[:id]
      @user = User.where(userid: params[:id]).first
    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return
    end


  end

  def update

    @user = User.where(userid: params[:id]).first
    @user.modified = Time.now

    
    @user.roleid = params[:user][:roleid]

    if params[:user][:firstname]
      @user.firstname = params[:user][:firstname]
    end

    if params[:user][:lastname]
      @user.lastname = params[:user][:lastname]
    end

    if params[:user][:email]
      @user.email = params[:user][:email]
    end

    if @user.save
      # If update succeeds, redirect to the index action
      flash[:notice] = "Updated User"
      redirect_to(:action => 'show', :id => @user.userid)
    else
      # If update fails, redisplay the form so user can fix problems
      render('edit')
    end

  end

  def new
  end

  def create
  end

  def show

    if session[:roleid] == ADMIN_ROLE || session[:userid] == params[:id]
      @user = User.where(userid: params[:id]).first
    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return
    end

  end

  def userautocomplete
    searchtext = params['searchText']


    # this will do a like search ignoring case
    @searchcauseresults = User.where("lastname ILIKE ?", "%" + searchtext + "%")
  
    render :json => @searchcauseresults

  end

  def user_params
    params.require(:user).permit(:firstname,:lastname,:email,:roleid)
  end

end
