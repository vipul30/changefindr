class GiftcardController < ApplicationController
  def index

    if session[:roleid] == ADMIN_ROLE && params[:viewall]

        @usergiftcards = Giftcard.order(modified: :desc)
                            .page(params[:page]).per_page(9)
    else
      @usergiftcards = Giftcard.where(:isdeleted => false)
                            .where(:userid => session[:userid])
                            .order(modified: :desc)
                            .page(params[:page]).per_page(9)
    end


    @usergiftcardscount = Giftcard.where(:isdeleted => false)
                      .where(:userid => session[:userid])
                      .count
  
    @giftcard = Giftcard.new

   
    @userhost = request.host_with_port

  end

  def delete

    @giftcard = Giftcard.where(:giftcardid => params[:id]).first()
    @giftcard.isdeleted = 1

    if @giftcard.save
      flash[:notice] = "Your gift card has been deleted"
      redirect_to(:controller => "giftcard", :action => "index")
    else
      flash[:notice] = "There was an error deleting the gift card.  Please try again or contact support."
      redirect_to(:controller => "giftcard", :action => "index")
    end


  end

  def edit
    @giftcard = Giftcard.where(:giftcardid => params[:id]).first()
  end

  def update

    # Find an existing object using form parameters
    @giftcard = Giftcard.where(:giftcardid => params[:id]).first()
    @giftcard.modified = Time.now
    
    # Update the object
    if @giftcard.update_attributes(giftcard_params)
      # If update succeeds, redirect to the index action
      flash[:notice] = "Updated Gift Card"
      redirect_to(:action => 'show', :id => @giftcard.giftcardid)
    else
      # If update fails, redisplay the form so user can fix problems
      flash[:notice] = "There was an error updating gift card."
      render('edit')
    end

  end

  def new

    @giftcard = Giftcard.new
    @giftcard.merchantid = params[:id]
    

  end

  def create

    @giftcard = Giftcard.new(giftcard_params)

    @giftcard.created = Time.now
    @giftcard.modified = Time.now
    @giftcard.balancecheckdate = Time.now
    @giftcard.userid = session[:userid]
    @giftcard.isdeleted = 0


    # call the method getcardbalance(cardnumber, pinnumber, productlineid)
    # returns a Bhnquote model object
    merchant = Merchant.where(:merchantid => @giftcard.merchantid).first

    if merchant != nil || merchant.merchantid != 85

      bhnquote = Bhnquote.new
      bhnquote = getcardbalance(@giftcard.cardnumber, @giftcard.pin, merchant.productLineId)


      if bhnquote.responsecode == '200' || bhnquote.responsecode == '201'

        @giftcard.balance = bhnquote.actualCardValue

      else
        # error
        bhnquote.giftcardid = nil
        bhnquote.save
        flash[:notice] = bhnquote.errorMessage
        render('new') 
        return
      end
    else
      flash[:notice] = 'Please select a valid gift card from the list.'
      render('new') 
      return

    end
    
    

    if @giftcard.save

      bhnquote.giftcardid = @giftcard.giftcardid
      bhnquote.save

      # if user is logged display main page
      if session[:userid]

        session[:usergiftcards] = nil

        session[:usergiftcards] = Giftcard.where(:isdeleted => false)
                      .where(:userid => session[:userid])
                      .order(modified: :desc)
                      .limit(2).to_yaml

        flash[:notice] = "Please see below for your gift card balance."
        redirect_to(:controller => "giftcard", :action => "index")
        return

      # else redirect the user to the registration screen and store the gift card info in the session
      else
        
        session[:newgiftcardid] = @giftcard.giftcardid
        flash[:notice] = "Please sign in or register in order to see balance."
        redirect_to(:controller => "sign_in", :action => "index")
        return

      end

    else
        # If save fails, redisplay the form so user can fix problems
        render('new')
        return
    end

  end

  def refreshbalance


    # if user is logged display main page
    if session[:userid]

      @giftcard = Giftcard.where(:giftcardid => params[:giftcardid]).first()

      # call the method getcardbalance(cardnumber, pinnumber, productlineid)
      # returns a Bhnquote model object
      merchant = Merchant.where(:merchantid => @giftcard.merchantid).first

      bhnquote = Bhnquote.new
      bhnquote = getcardbalance(@giftcard.cardnumber, @giftcard.pin, merchant.productLineId)


      if bhnquote.responsecode == '200' || bhnquote.responsecode == '201'

        @giftcard.balance = bhnquote.actualCardValue

      else
        # error
        flash[:notice] = bhnquote.errorMessage
        render('new') 
        return
      end
       

      if @giftcard.save

        bhnquote.giftcardid = @giftcard.giftcardid
        bhnquote.save

        session[:usergiftcards] = nil

        session[:usergiftcards] = Giftcard.where(:isdeleted => false)
                      .where(:userid => session[:userid])
                      .order(modified: :desc)
                      .limit(2).to_yaml

        flash[:notice] = "Please see below for your gift card balance."
        redirect_to(:controller => "giftcard", :action => "index")
        return
      else
        flash[:notice] = "There was an error refreshing the balance.  Please try again later."
        # If save fails, redisplay the form so user can fix problems
        render('index')
        return
    
      end

      # else redirect the user to the registration screen and store the gift card info in the session
      else
        
        session[:newgiftcardid] = @giftcard.giftcardid
        flash[:notice] = "Please sign in or register in order to see balance."
        redirect_to(:controller => "sign_in", :action => "index")
        return

      end


  end

  def show
    @giftcard = Giftcard.where(:giftcardid => params[:id]).first()
    
  end

  def giftcard_params
    params.require(:giftcard).permit(:merchantid,:pin,:expdate,:eventnumber,:cardnumber)
  end

end
