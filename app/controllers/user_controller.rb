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
  end

  def update
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

end
