class UserMailer < ActionMailer::Base
  default from: "Support Changefindr <no-reply@changefindr.com>"
  layout 'mailerlayout' # use mailerlayout.(html|text).erb as the layout

	def welcome_email(user, currenthost)
	    @user = user
	    @currenthost = currenthost
	    @url  = 'http://example.com/login'

	    mail(to: @user.email, subject: 'Welcome to Changefindr')
	end


end
