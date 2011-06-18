class LkAuthenticationController < ApplicationController

before_filter :linkedin_client

def index
request_token = @client.request_token(:oauth_callback => "http://#{request.host_with_port}/lk_authentication/callback")
session[:rtoken] = request_token.token
session[:rsecret] = request_token.secret
redirect_to @client.request_token.authorize_url
end

def callback
    if session[:atoken].nil?
      atoken, asecret =  @client.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
      pin = params[:oauth_verifier]
      p "client.authorize_from_request('#{session[:rtoken]}', '#{session[:rsecret]}', '#{params[:oauth_verifier]}')"
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      @client.authorize_from_access(session[:atoken], session[:asecret])

    end

    @profile = @client.profile(:fields => [:first_name])
    @connections = @client.connections
end

def kill_access_token_session
      session[:asecret], session[:atoken] = nil
      redirect_to "/users/login"
end

private 

def linkedin_client
   @client = LinkedIn::Client.new("0Gh5FjjpmVdIo-YW1RXzS-BuZLTLZRKt3wmKzRS8yCpT-S6dcpavFSGda-pA2a7g", "WMnoSbl3_zkyCe3qslZD7pFX8z8i6FZvRjYEdXv7dgO7diZ0RZj9IP_zunawhHUM")
end

end
