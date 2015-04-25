class CauseMailer < ActionMailer::Base
  default from: "Support Changefindr <no-reply@changefindr.com>"
  layout 'mailerlayout' # use mailerlayout.(html|text).erb as the layout

	def cause_email(cause, currenthost)
	    @cause = cause
	    @currenthost = currenthost

	    mail(to: @cause.email, subject: 'Changefindr - New Cause')
	    mail(bcc: 'vipul30@gmail.com', subject: 'Changefindr - New Cause')
	end


	

end
