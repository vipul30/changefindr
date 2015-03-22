class MerchantController < ApplicationController
  
  def index

    @merchants = Merchant.where.not(merchantid: 172).order('merchantname ASC').page(params[:page]).per_page(9)
  
    @userhost = request.host_with_port

  end

  def create

    @merchant = Merchant.new(merchant_params)
   
    
    if @merchant.save
        flash[:notice] = "Merchant Added"
        redirect_to(:controller => "home", :action => "index")
        return
    else
      # If save fails, redisplay the form so user can fix problems
      flash[:notice] = "There was an error creating the merchant."
      render('new')
    end

  end

  def edit

    if session[:roleid] == 1

      @merchant = Merchant.where(merchantid: params[:id]).first
      return
    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
    end

  end

  def update

    @merchant = Merchant.where(merchantid: params[:id]).first
    
    # Update the object
    if @merchant.update_attributes(merchant_params)
      # If update succeeds, redirect to the index action
      flash[:notice] = "Updated Merchant"
      redirect_to(:action => 'index')
    else
      # If update fails, redisplay the form so user can fix problems
      flash[:notice] = "Failed to update."
      render('edit')
    end
  end

  def delete

  end

  def show

  end

  def new

    if session[:roleid] == 1
      @merchant = Merchant.new
    else
      # If save fails, redisplay the form so user can fix problems
      flash[:notice] = "There was an error creating the merchant."
      render('new')
    end

  end


  def merchantautocomplete
    searchtext = params['searchText']

    # this will do a like search ignoring case
    @searchmerchantresults = Merchant.where("merchantname ILIKE ?", "%" + searchtext + "%")
                                     .where(:productLineStatus => 'ACTIVATED')                         
    
    render :json => @searchmerchantresults

  end

  def merchant_params
    params.require(:merchant).permit(:merchantname,:phonenumber,:checkbalanceurl,:description,:logo)
  end

end
