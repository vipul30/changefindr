class BlogController < ApplicationController
  def index
    @blogs = Blog.where(is_active: true).order('modified ASC')
    

  end

  def show

    @blog = Blog.where(blog_id: params[:blog_id]).first

  end

  def new

    @blog = Blog.new
  end

  def edit
    @blog = Blog.where(blog_id: params[:blog_id]).first
  end

  def update
    @blog = Blog.where(blog_id: params[:blog_id]).first
    @blog.modified = Time.now

    # Update the object
    if @blog.update_attributes(blog_params)
      # If update succeeds, redirect to the index action
      flash[:notice] = "Updated Blog"
      redirect_to(:action => 'show', :blog_id => @blog.blog_id)
    else
      # If update fails, redisplay the form so user can fix problems
      render('edit')
    end

  end

  def create

    @blog = Blog.new(blog_params)
    @blog.created = Time.now
    @blog.modified = Time.now
    @blog.is_active = true

    user = User.where(email: session[:username]).first

    # see if this email exists in the database.  if so attach the user id to the person.
    if (user == nil)

      user = User.where(email: params[:blog][:email]).first

    end


    if (user != nil)
      @blog.first_name = user.firstname
      @blog.last_name = user.lastname
      @blog.email = user.email
      @blog.user_id = user.userid
    end

    if @blog.save
        flash[:notice] = "Thank you for your blog entry."
        
        redirect_to(:controller => "blog", :action => "index")
        return
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end

  end

  def delete
    @blog = Blog.where(blog_id: params[:blog_id]).first
    @blog.modified = Time.now
    @blog.is_active = false

    # Update the object
    if @blog.save
      # If update succeeds, redirect to the index action
      flash[:notice] = "Deleted Blog"
      redirect_to(:action => 'index')
    else
      # If update fails, redisplay the form so user can fix problems
      render('edit')
    end
  end

  def blog_params
    params.require(:blog).permit(:first_name,:last_name,:title,:description,:email,:keywords)
  end

end
