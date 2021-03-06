class Api::TokensController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def create
    email = params[:email]
    password = params[:password]
    recover = params[:recover]

    if request.format != :json
      render :status=>200, :json => {:response => {:message => "The request must be json.",:success => false}}, :callback => params[:callback]
      return
    end

    if email and recover
      # @user = User.find_by_email(email.downcase)
      # if @user.nil?
      #   logger.info("User #{email} failed signin, user cannot be found.")
      #   render :status => 200, :json => {:response => {:message => "Invalid email.",:success => false}}, :callback => params[:callback]
      #   return
      # end
      # network = @user.networks.first if @user.networks.first
      # password_length = 6
      # password = Devise.friendly_token.first(password_length)
      # #password = User.generate_token('password')
      # # User.create!(:email => 'someone@something.com', :password => password, :password_confirmation => password)
      # @user.password = password
      # puts '-------------------'
      # # puts password
      # if(@user.save)
      #   UserMailer.user_password(@user, network, password).deliver
      #   render :status => 200, :json => {:response => {:message => "Se ha enviado tu contrasena a tu Email",:success => true}}, :callback => params[:callback]
      # else
      #   render :status => 200, :json => {:response => {:message => "El usuario no existe, verifica tu Email ",:success => true}}, :callback => params[:callback]
      # end
      # return
    end

    if email.nil? or password.nil?
      render :status => 200, :json => {:response => {:message => "The request must contain the user email and password.",:success => false}}, :callback => params[:callback]
      return
    end

    @user = User.find_by_email(email.downcase)

    if @user.nil?
      logger.info("User #{email} failed signin, user cannot be found.")
      render :status => 200, :json => {:response => {:message => "Invalid email or password.",:success => false}}, :callback => params[:callback]
      return
    end    
    
    
    # http://rdoc.info/github/plataformatec/devise/master/Devise/Models/TokenAuthenticatable
    @user.ensure_authentication_token!
    
    if not @user.valid_password?(password)
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid.")
      render :status => 200, :json => {:response =>{:message => "Invalid email or password.", :success => false}}, :callback => params[:callback]
    else
      render :status => 200, :json => {:response =>{:user => @user, :auth_token => @user.authentication_token,:success => true}}, :callback => params[:callback]
    end
  end
  
  def destroy
    @user=User.find_by_authentication_token(params[:id])
    if @user.nil?
      logger.info("Token not found.")
      render :status => 404, :json => {:response =>{:message => "Invalid token", :success => false}}
    else
      @user.reset_authentication_token!
      render :status => 200, :json => {:response =>{:token => params[:id], :success => true}}
    end
  end 
end