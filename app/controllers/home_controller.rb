class HomeController < ApplicationController
  def index

  	offset = rand(Charity.count)

  	@causes = Charity.limit(20).order("RANDOM()").where(isapproved: true)

    @merchants = Merchant.where.not(merchantid: 172).limit(20).order("RANDOM()")

  	@userhost = request.host_with_port

    if session[:usergiftcardscount]
    
      @usergiftcards = Giftcard.where(:isdeleted => false)
                        .where(:userid => session[:userid])
                        .order(modified: :desc)
                        .limit(2)

      @usergiftcardscount = Giftcard.where(:isdeleted => false)
                        .where(:userid => session[:userid])
                        .count
    end


    if @usergiftcards
  	   @giftcardstats = Giftcardstat.limit(3).order("RANDOM()")
    end


  end


  def newslettersignup

    @nletter = Newsletter.new
    @nletter.email = params[:email]
    @nletter.created = Time.now
    @nletter.modified = Time.now
    @nletter.isactive = true
    @message = ''


    if @nletter.email == nil

      @message = "Please enter an email address."

    # check if active email already exists
    elsif Newsletter.where(:email => @nletter.email)
                  .where(:isactive => true).first


      @message = "You are already receiving treats from us."
      
    elsif @nletter.save

      @message = "Thank you for adding your email to our newsletter"
      
    else
      
      if @nletters != nil
        if @nletters.errors
          @nletters.errors.messages.values.each do |msg|
            @message = msg
            break
          end
        else  
          @message = "Invalid email."
        end
      else
        @message = "Invalid email."
      end

    end


    render :json => @message.to_json

    #redirect_to(:back) 
    
  end

  def mailerlayout
  	
  	render ('user_mailer/mailerlayout')
  end

end
