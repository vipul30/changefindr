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

    user = User.where(email: session[:username]).first

    if (user == nil)
      flash[:notice] = "Your user session is invalid.  Please login and try submission again."
      redirect_to(:controller => "home", :action => "index")
      return
    end

    @cause.email = user.email
    @cause.userid = user.userid
    @cause.contactname = user.firstname + ' ' + user.lastname

    if @cause.save
        flash[:notice] = "Thank you for submission.  We will contact you once your cause is approved."
        redirect_to(:controller => "home", :action => "index")
        return
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end


  end

  def edit
    @cause = Charity.where(charityid: params[:id]).first
    byebug
  end


  def update

  end

  def show
  end

  def delete
  end

  def user_params
    params.require(:charity).permit(:charityname,:website,:facebookurl,:description,:logo,:image1,:image2,:image3)
  end

end
