class SessionsController < ApplicationController

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    session[:logged_on_user_id] = @user.id
    session[:twitter_user_token] = auth_hash.credentials.token
    session[:twitter_user_secret] = auth_hash.credentials.secret
    redirect_to root_path
  end

  def destroy
    if current_user
      session.delete(:logged_on_user_id)
      session.delete(:twitter_user_token)
      session.delete(:twitter_user_secret)
      flash[:success] = "Sucessfully logged out!"
    end
    redirect_to root_path
  end

  protected
 
  def auth_hash
    request.env['omniauth.auth']
  end
end
