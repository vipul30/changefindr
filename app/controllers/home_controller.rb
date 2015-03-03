class HomeController < ApplicationController
  def index

  	

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

  def error
    flash[:notice] = "There was an error processing your request.  An email has been sent to the administrator."
    redirect_to(:controller => "home", :action => "index")
  end

end
