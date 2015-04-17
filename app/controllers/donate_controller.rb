class DonateController < ApplicationController
  def index


    if session[:roleid] == ADMIN_ROLE && params[:viewall]
      @donations = Donation.order('created DESC').page(params[:page]).per_page(9)

    elsif session[:userid] == params[:userid] || session[:roleid] == ADMIN_ROLE
      @donations = Donation.where(userid: params[:userid]).order('created DESC').page(params[:page]).per_page(9)
      
    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return
    end


  end

  def new

    @donation = Donation.new
    @giftcard = Giftcard.new


    if !params[:merchantid].nil? && !params[:merchantid].empty?
       
      @giftcard.merchantid = params[:merchantid]
      session[:merchantid] = params[:merchantid]

    elsif session[:merchantid]

      @giftcard.merchantid = session[:merchantid]

    end

    if !params[:giftcardid].nil? && !params[:giftcardid].empty?
      
      @giftcard = Giftcard.where(:giftcardid => params[:giftcardid]).first()
      session[:giftcardid] = @giftcard.giftcardid

    elsif session[:giftcardid]

      session[:merchantid] = nil
      @giftcard = Giftcard.where(:giftcardid => session[:giftcardid]).first()

    end



    if params[:charityid].nil? || params[:charityid].empty?
      redirect_to(:controller => "cause", :action => "index")
      return
    else
      @donation.charityid = params[:charityid]
    end

    @donation.giftcard = @giftcard
    

  end

  def create

    @donation = Donation.new(donate_params)
    @donation.created = Time.now
    @donation.modified = Time.now

    
    
    if !params[:donation][:giftcard_attributes][:giftcardid].empty?
      @donation.giftcard.giftcardid = params[:donation][:giftcard_attributes][:giftcardid]
      @donation.giftcardid = params[:donation][:giftcard_attributes][:giftcardid]
      
    else
      if @donation.giftcard == nil
        @donation.giftcard = Giftcard.new
      end

      @donation.giftcard.created = Time.now
      @donation.giftcard.modified = Time.now
      @donation.giftcard.balancecheckdate = Time.now
      
      @donation.giftcard.merchantid = 85 # gift card not found
    end
    
    if @donation.giftcard.created == nil
      @donation.giftcard.created = Time.now
      @donation.giftcard.modified = Time.now
      @donation.giftcard.balancecheckdate = Time.now
    end
   
    @giftcard = @donation.giftcard


    if session[:userid]
      @donation.userid = session[:userid]
      @donation.giftcard.userid = session[:userid]
    end
    
    @donation.giftcard.isdeleted = 0


    # call the method getcardbalance(cardnumber, pinnumber, productlineid)
    # returns a Bhnquote model object
    merchant = Merchant.where(:merchantid => @donation.giftcard.merchantid).first

    if merchant.merchantid != 85
      bhnquote = Bhnquote.new
      bhnquote = getcardbalance(@donation.giftcard.cardnumber, @donation.giftcard.pin, merchant.productLineId)


      if bhnquote.responsecode == '200' || bhnquote.responsecode == '201'

       @donation.giftcard.balance = bhnquote.actualCardValue

      else
        # error
        # only display error message if invalid number of balance is 0, otherwise we will process on the backend
        if bhnquote.errorMessage == 'The card number is invalid or there is no value on the card.'
          flash[:notice] = bhnquote.errorMessage
          render('new') 
          return
        end
      end
    end


    if @donation.save

      if merchant.merchantid != 85
          # check if the product line is accepted by bhn 
          # save the bhn quote
          bhnquote.giftcardid = @donation.giftcard.giftcardid
          bhnquote.save

          # call the method to have bhn acquire the donation
          bhnacquire = Bhnacquire.new
          bhnacquire = bhnacquirecard(@donation)
          
          bhnacquire.save

        flash[:notice] = 'Thank you for your donation in the amount of ' + number_to_currency(@donation.giftcard.balance).to_s + ' to ' + @donation.charity.charityname + '.  Please hold onto your gift card until you get an email from us informing you we have processed it.'
      
      else
          flash[:notice] = 'Thank you for your donation to ' + @donation.charity.charityname + '.  Please hold onto your gift card until you get an email from us informing you we have processed it.'
      
      end

      DonateMailer.donate_email(@donation, request.host_with_port).deliver
      redirect_to(:controller => "home", :action => "index")
      return

    else

      render('new')
    end

    if session[:userid]
      user = User.where(:userid => session[:userid]).first
      initializelogin(user)
    end

  end

  def edit

    if session[:roleid] == ADMIN_ROLE
      @donation = Donation.where(donationid: params[:id]).first
      @giftcard = @donation.giftcard
    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return
    end

  end

  def update

    @donation = Donation.where(donationid: params[:id]).first
    
    @donation.modified = Time.now
    @donation.giftcard.modified = Time.now
    @giftcard = @donation.giftcard


    
    # Update the object
    if @donation.update_attributes(donate_params)
      flash[:notice] = "Donation information has been updated"
      redirect_to(:controller => "donate", :action => "show", :donationid => @donation.donationid)
      return
    else

      render('edit')
    end

  end

  def show

    if session[:roleid] == ADMIN_ROLE || session[:userid] == params[:userid]
      @donation = Donation.where(donationid: params[:donationid]).first
    else
      flash[:notice] = "You are not authorized to view this page."
      redirect_to(:controller => "home", :action => "index")
      return
    end


  end

  def delete
  end

  def donate_params
    params.require(:donation).permit({:giftcard_attributes =>  [:cardnumber,:merchantid,:pin,:expdate,:eventnumber]},
                                     :firstname,:lastname,:email,:comments,:donationwall,:charityid)
  end

 
end
