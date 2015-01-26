class GiftcardController < ApplicationController
  def index
  end

  def delete
  end

  def edit
  end

  def new

    @giftcard = Giftcard.new
    @giftcard.merchantid = params[:id]
    

  end

  def create

    @giftcard = Giftcard.new(giftcard_params)

    # if user is logged in, continue to get balance and add the gift card
    if session[:userid]

    # else redirect the user to the registration screen and store the gift card info in the session
    else
      
    end

  end

  def show
  end

  def giftcard_params
    params.require(:giftcard).permit(:merchantid,:cardnumber,:pin,:expdate,:eventnumber)
  end

end
