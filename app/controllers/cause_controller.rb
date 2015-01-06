class CauseController < ApplicationController
  def index
  end

  def new

    @cause = Charity.new

  end


  def create

    @cause = Charity.new(user_params)
    @cause.created = Time.now
    @cause.modified = Time.now

    if @cause.save
        flash[:notice] = "Thank you for submission.  We will contact you once your cause is approved."
        redirect_to(:controller => "home", :action => "index")
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end


  end

  def edit
  end

  def show
  end

  def delete
  end

  def user_params
    params.require(:charity).permit(:charityname,:website,:facebookurl,:description,:logo,:image1,:image2,:image3)
  end

end
