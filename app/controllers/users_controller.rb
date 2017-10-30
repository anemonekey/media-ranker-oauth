class UsersController < ApplicationController
  skip_before_action :require_login, only: [:login]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def login
    auth_hash = request.env['omniauth.auth']

    if auth_hash['uid']
      user = User.find_by(provider: params[:provider], uid: auth_hash['uid'])
      if user.nil?
        user = User.from_auth_hash(params[:provider], auth_hash)
        save_and_flash(user)

      else
        flash[:status] = :success
        flash[:message] = "Successfully logged in as returning user #{user.name}"

      end

      # Log the user in
      session[:user_id] = user.id

    else
      flash[:status] = :failure
      flash[:message] = "Failed to create new user from data"
    end

    redirect_to root_path
  end


  # def logout
  #   session[:user_id] = nil
  #   flash[:status] = :success
  #   flash[:message] = "Successfully logged out!"
  #   redirect_to root_path
  # end
end
