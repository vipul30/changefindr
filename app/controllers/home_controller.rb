class HomeController < ApplicationController
  def index

	offset = rand(Charity.count)

	@causes = Charity.limit(20).order("RANDOM()").where(isapproved: true)

  @merchants = Merchant.where.not(merchantid: 172).limit(20).order("RANDOM()")

	@userhost = request.host_with_port

	

  end

  def mailerlayout
  	
  	render ('user_mailer/mailerlayout')
  end

end
