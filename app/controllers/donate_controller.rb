class DonateController < ApplicationController
  def index
  end

  def new

    @donation = Donation.new
    @giftcard = Giftcard.new

    if !params[:giftcardid].nil? && !params[:giftcardid].empty?
      
      @giftcard = Giftcard.where(:giftcardid => params[:id]).first()

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
    @donation.giftcard.cardnumber_hash = params[:cardnumber]
    @donation.giftcard.created = Time.now
    @donation.giftcard.modified = Time.now
    @donation.giftcard.balancecheckdate = Time.now
    @giftcard = @donation.giftcard

    if session[:userid]
      @donation.userid = session[:userid]
      @donation.giftcard.userid = session[:userid]
    end
    
    @donation.giftcard.isdeleted = 0
    @donation.giftcard.balance = (rand * (45-5) + 5).round(2)
    
    if @donation.save
      flash[:notice] = "Thank you for your donation.  Please hold onto your gift card until you get an email from us informing you we have processed it."
      redirect_to(:controller => "home", :action => "index")
      return
    else

      render('new')
    end

    

  end

  def edit
  end

  def update
  end

  def show
  end

  def delete
  end

  def donate_params
    params.require(:donation).permit({:giftcard_attributes =>  [:merchantid,:pin,:expdate,:eventnumber]},
                                     :firstname,:lastname,:email,:comments,:donationwall,:charityid)
  end

 
end
