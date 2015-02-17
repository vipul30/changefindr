class ErrorsController < ApplicationController
  include Gaffe::Errors

   # Make sure anonymous users can see the page
  skip_before_filter :authenticate_user!

  # Override 'error' layout
  layout 'application'

  def show
  end
end
