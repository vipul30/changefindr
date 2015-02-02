class TermsconditionsController < ApplicationController
  def index
  end

  def index_no_layout
  	render :layout => false
  end
end
