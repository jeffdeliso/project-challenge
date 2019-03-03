class ApplicationController < ActionController::Base

  def ensure_loggin
    redirect_to dogs_url unless current_user
  end
  
end
