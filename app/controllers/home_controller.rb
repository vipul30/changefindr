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

  def mailerlayout
  	
  	render ('user_mailer/mailerlayout')
  end

end
