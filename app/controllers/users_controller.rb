class UsersController < ApplicationController
  
  def login
  end
  
  def my_profile
    session[:atoken] 
      session[:asecret] 
  end
end