class KanbansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  
  def show
    @tasks = {
      todo: @project.tasks.where(status: 'todo').order(priority: :desc, created_at: :desc),
      in_progress: @project.tasks.where(status: 'in_progress').order(priority: :desc, created_at: :desc),
      done: @project.tasks.where(status: 'done').order(priority: :desc, created_at: :desc)
    }
  end
  
def update_status
  @task = @project.tasks.find(params[:task_id])
  @task.update(status: params[:status])
  
  respond_to do |format|
    format.json { render json: { success: true, task: @task } }
    format.html { redirect_back fallback_location: project_kanban_path(@project) }
  end
end
  
  private
  
  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end