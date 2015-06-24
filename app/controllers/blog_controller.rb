class BlogController < ApplicationController
  def index
  end

  def show
  end

  def new

    @blog = Blog.new
  end

  def edit
  end

  def update
  end

  def create
  end

  def delete
  end

  def blog_params
    params.require(:charity).permit(:first_name,:last_name,:title,:description)
  end

end
