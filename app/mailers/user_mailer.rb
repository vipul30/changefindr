class UserMailer < ActionMailer::Base
  default from: "Support Changefindr <no-reply@changefindr.com>"
  layout 'mailerlayout' # use mailerlayout.(html|text).erb as the layout

	def welcome_email(user, currenthost)
	    @user = user
	    @currenthost = currenthost

	    mail(to: @user.email, subject: 'Welcome to Changefindr')
	end


	def resetpassword_email(user, currenthost)
	    @user = user
	    @currenthost = currenthost

	   
	    mail(to: @user.email, subject: 'Changefindr - Reset Password')
	end

end
