class DonateController < ApplicationController
  def index


    if session[:roleid] == ADMIN_ROLE && params[:viewall]
      @donations = Donation.order('created DESC').page(params[:page]).per_page(9)

    elsif session[:userid] == params[:userid] || session[:roleid] == ADMIN_ROLE
      @donations = Donation.where(userid: params[:userid]).order('created DESC').page(params[:page]).per_page(9)
      
    else
      flash[:notice] = "Please login or register in order to view your donations."
      redirect_to(:controller => "home", :action => "index")
      return
    end


  end

  def new

    if params[:partnersite] != nil && params[:partnersite] == 'true'

      # comes from a partnersite and do not show header and footer
      session[:partnersite] = true
      session[:returnurl] = params[:returnurl]
      session[:partnercharityid] = params[:charityid]

    end

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

    
    if !params[:donation][:giftcard_attributes][:merchantid].empty?
      @donation.giftcard.giftcardid = params[:donation][:giftcard_attributes][:giftcardid]
      @donation.giftcardid = params[:donation][:giftcard_attributes][:giftcardid]
      @donation.giftcard.merchantid = params[:donation][:giftcard_attributes][:merchantid]
      
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


    donorname = ''
    donoremail = ''

    if session[:userid]
      @donation.userid = session[:userid]
      @donation.giftcard.userid = session[:userid]

      donorname = @donation.user.firstname + ' ' + @donation.user.lastname
      donoremail = @donation.user.email
    else
      donorname = @donation.firstname + ' ' + @donation.lastname
      donoremail = @donation.email
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
       @donation.giftcard.isdonated = 1

      else


        # error
        # only display error message if invalid number of balance is 0, otherwise we will process on the backend
        if bhnquote.errorCode == 'exchange.invalid.card' ||
          bhnquote.errorCode == 'exchange.pinNumber.is.blank' ||
          bhnquote.errorCode == 'exchange.cardNumber.is.blank'
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

        @message = 'Thank you for your donation in the amount of ' + number_to_currency(@donation.giftcard.balance).to_s + ' to ' + @donation.charity.charityname + '.  Please hold onto your gift card until you get an email from us informing you we have processed it.'
      
      else
          @message = 'Thank you for your donation to ' + @donation.charity.charityname + '.  Please hold onto your gift card until you get an email from us informing you we have processed it.'
      
      end

      flash[:notice] = nil
      
      DonateMailer.donate_email(@donation, request.host_with_port).deliver

      # reset everything for a new donation
      session[:giftcardid] = nil
      session[:merchantid] = nil
      session[:donationscount] = 1 # so the option to view donations displays in the menu dropdown for the user
      
      if session[:partnersite] == true

        url = session[:returnurl] + '/changefindr?donor=' + donorname + '&donoremail=' + donoremail 

        encoded_url = URI.encode(url)

        redirect_to encoded_url
        return
      else
        redirect_to(:controller => "donate", :action => "thankyou", :message => @message)
        return
      end

      

    else

      render('new')
    end

    if session[:userid]
      user = User.where(:userid => session[:userid]).first
      initializelogin(user)
    end

  end

  def thankyou
    @message = params[:message]
    
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
