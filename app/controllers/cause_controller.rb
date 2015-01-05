class CauseController < ApplicationController
  def index
  end

  def new

    @cause = Charity.new
  end


  def create

    @newcause = Charity.new(user_params)



    @newcause.save
  end

  def edit
  end

  def show
  end

  def delete
  end

  def user_params
    params.require(:charity).permit(:avatar)
  end

end
