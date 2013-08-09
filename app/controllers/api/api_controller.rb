class Api::ApiController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_filter :authorize 
  
  respond_to :json
  def course_requests
    course_request = @user.enrollment_requests.find params[:id]    
    if params[:accept] == true
      course_request.accept!
    else
      course_request.reject!
    end    
    render :json => {:success => true}, :callback => params[:callback]    
  end

  private 
  def authorize
    @user=User.find_by_authentication_token(params[:auth_token])
    @network = @user.networks[0]
    if @user.nil?
       logger.info("Token not found.")
       render :status => 200, :json => {:message => "Invalid token", :success => false}        
    end
  end  
end
