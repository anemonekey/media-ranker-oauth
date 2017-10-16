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
      else
      end # end user.nil? if-else 
    else
    end # end auth_hash['uid'] if-else
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:message] = "Successfully logged out!"
    redirect_to root_path
  end
end
