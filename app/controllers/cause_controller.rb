class CauseController < ApplicationController
  def index
    @causes = Charity.where(isapproved: true).order('modified DESC').page(params[:page]).per_page(9)
  
    @cause = Charity.new

    @userhost = request.host_with_port
  end

  def new

    @cause = Charity.new


  end

  def create

    @cause = Charity.new(cause_params)
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

  end


  def update
    # Find an existing object using form parameters
    @cause = Charity.where(charityid: params[:id]).first
    @cause.modified = Time.now

    if params["chkboximg1"] == "true"
      @cause.image1 = nil
    end

    if params["chkboximg2"] == "true"
      @cause.image2 = nil
    end

    if params["chkboximg3"] == "true"
      @cause.image3 = nil
    end


    # Update the object
    if @cause.update_attributes(cause_params)
      # If update succeeds, redirect to the index action
      flash[:notice] = "Updated Cause"
      redirect_to(:action => 'show', :id => @cause.charityid)
    else
      # If update fails, redisplay the form so user can fix problems
      render('edit')
    end

  end

  def show
    @cause = Charity.where(charityid: params[:id]).first
    @shortcauseurl = request.host_with_port + "/cause/show/" +  @cause.charityid.to_s
  end

  def delete
  end

  def cause_params
    params.require(:charity).permit(:charityname,:website,:facebookurl,:description,:logo,:image1,:image2,:image3,:isapproved,:isfeatured)
  end

  #autocomplete :charity, :charityname, :full => true

  def causeautocomplete
    searchtext = params['searchText']

    # this will do a like search ignoring case
    @searchcauseresults = Charity.where("charityname ILIKE ?", "%" + searchtext + "%")
                                 .where(isapproved: true)
    
    render :json => @searchcauseresults

  end


end
