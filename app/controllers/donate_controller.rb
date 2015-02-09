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
  end

  def edit
  end

  def update
  end

  def show
  end

  def delete
  end
end
