class DonateMailer < ActionMailer::Base
  default from: "Support Changefindr <no-reply@changefindr.com>"
  layout 'mailerlayout' # use mailerlayout.(html|text).erb as the layout

	def donate_email(donation, currenthost)
	    @donation = donation
	    @currenthost = currenthost

	    if !@donation.userid.blank? 
	    	email = @donation.user.email
	    else
	    	email = @donation.email
	    end

	    begin
	    	mail(to: email, subject: 'Changefindr - Donation').deliver()
	    rescue
	    end

	    begin
	    	mail(to: 'vipul30@gmail.com', subject: 'Changefindr - Donation').deliver()
	    rescue
	    	byebug
	    end

	    begin
	    	mail(to: 'founder921@gmail.com', subject: 'Changefindr - Donation').deliver()
	    rescue
	    end
	end


	

end
