class BhnMailer < ActionMailer::Base
  default from: "Support Changefindr <no-reply@changefindr.com>"
  layout 'mailerlayout' # use mailerlayout.(html|text).erb as the layout

	def bhn_error_email(emailmessage)
	    
	    @emailmessage = emailmessage

	    mail(to: 'vipul@changefindr.com', subject: 'BHN API Error')
	end


end
