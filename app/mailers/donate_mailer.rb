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

	    mail(to: email, subject: 'Changefindr - Donation')
	    mail(bcc: 'vipul30@gmail.com', subject: 'Changefindr - Donation')
	end


	

end
