class HomeController < ApplicationController
  def index

	offset = rand(Charity.count)

	@causes = Charity.limit(20).order("RANDOM()").where(isapproved: true)



	@userhost = request.host_with_port

  end
end
