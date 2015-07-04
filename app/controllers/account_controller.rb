class AccountController < ApplicationController
  def index

    if (session[:account_id] == params[:account_id] || session[:roleid] == ADMIN_ROLE) && params[:account_id] != nil

      @accounts = Account.where(id: params[:account_id]).order('company_name ASC').page(params[:page]).per_page(9)

      if @accounts.size == 1
        redirect_to(:controller => "cause", :action => "index", :account_id => params[:account_id])
      end

    elsif session[:roleid] == ADMIN_ROLE  

      @accounts = Account.order('company_name ASC').page(params[:page]).per_page(9)

    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return

    end


  end

  def show

  if (session[:account_id] == params[:id] || session[:roleid] == ADMIN_ROLE) && params[:id] != nil
    @account = Account.where(id: params[:id]).first
  else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return

    end

  end

  def new

    @account = Account.new

  end

  def create

    @account = Account.new(account_params)
    @account.created = Time.now
    @account.modified = Time.now
    @account.is_active = true

    @account.api_key = ((0...20).map { ('a'..'z').to_a[rand(26)] }.join).upcase

    if @account.save
        flash[:notice] = "Account has been created."
        redirect_to(:controller => "account", :action => "index")
        return
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end


  end

  def update

    # Find an existing object using form parameters
    @account = Account.where(id: params[:id]).first
    @account.modified = Time.now

    # Update the object
    if @account.update_attributes(account_params)
      # If update succeeds, redirect to the index action
      flash[:notice] = "Updated Account"
      redirect_to(:action => 'show', :id => @account.id)
    else
      # If update fails, redisplay the form so user can fix problems
      render('edit')
    end

  end

  def edit

    @account = Account.where(id: params[:id]).first

  end



  def delete
  end

  def account_params
    params.require(:account).permit(:company_name,:company_url,:is_active)
  end

end
