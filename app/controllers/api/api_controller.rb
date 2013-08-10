class Api::ApiController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  before_filter :authorize 
  
  respond_to :json
  # def list_todos
  #   course_request = @user.enrollment_requests.find params[:id]    
  #   if params[:accept] == true
  #     course_request.accept!
  #   else
  #     course_request.reject!
  #   end    
  #   render :json => {:success => true}, :callback => params[:callback]    
  # end

  def list_todos
    todos = @user.todos.order('deadline ASC')
    render :json => {:todos => todos.as_json(:include => [:user])}, :callback => params[:callback]
  end

  def add_todo
    if params[:id].to_i != 0
      @todo = Todo.find(params[:id])
    else
      @todo = Todo.new
    end
    
    @todo.description = params[:description]
    @todo.user = @user
    @todo.deadline = params[:deadline]
    @todo.done = params[:done]

    if @todo.save!
      render :json => {:response =>{:todo => @todo, :success => true}}, :callback => params[:callback]
    else
      render :json => {:response =>{:message => 'No se pudo guardar :(',:success => false}}, :callback => params[:callback]
    end
  end
  def delete_todo
    @todo = Todo.find(params[:id])
    @todo.destroy
    render :json => {:response =>{:message => 'Tarea borrada :)',:success => true}}, :callback => params[:callback]
  end

  private 
  def authorize
    @user=User.find_by_authentication_token(params[:auth_token])
    if @user.nil?
       logger.info("Token not found.")
       render :status => 200, :json => {:message => "Invalid token", :success => false}        
    end
  end  
end
