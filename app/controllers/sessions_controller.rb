class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:login]
  # def login_form
  # end

  def login
    auth_hash = request.env['omniauth.auth']
    if auth_hash['uid']
      #if there is a user id check if the user is new or already exists
      user = User.find_by(provider: params[:provider], uid: auth_hash['uid'])
      if user.nil?
        #user is new
        user = User.from_auth_hash(params[:provider], auth_hash)
        if user.save
          #new user saves fine
          session[:user_id] = user.id
          flash[:status] = :success
          flash[:result_text] = "Successfully logged in as new user #{user.name}"
        else
          #new user cannot be saved, ex. the auth_hash has no provider
          flash[:status] = :failure
          flash[:result_text] = "Could not log on as new user #{auth_hash['name']}"
        end

      else
        #user has logged in before
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:result_text] = "Successfully logged in as new user #{user.name}"
      end

    else
      #auth hash has no user id
      flash[:status] = :failure
      flash[:result_text] = "Authentication with github failed"
    end
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "You have been logged out"
    redirect_to root_path
  end
end
