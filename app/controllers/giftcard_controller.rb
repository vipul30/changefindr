class GiftcardController < ApplicationController
  def index
  end

  def delete
  end

  def edit
  end

  def new

    @giftcard = GiftCard.where(giftcardid: params[:id]).first

    if (@giftcard == nil)
      @giftcard = GiftCard.new
    end

  end

  def show
  end
end
