class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_task, only: [:show, :edit, :update, :destroy]

def index
  @tasks = @project.tasks
end

  def show
  end

def new
  @task = @project.tasks.build(status: 'todo')
end

  def edit
  end

def create
  @task = @project.tasks.build(task_params)
  @task.user = current_user

  respond_to do |format|
    if @task.save
      format.html { 
        if request.referer&.include?('kanban')
          redirect_back fallback_location: project_kanban_path(@project), notice: "Задача успешно создана!"
        else
          redirect_to project_task_path(@project, @task), notice: "Задача успешно создана!"
        end
      }
      format.json { render :show, status: :created, location: @task }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @task.errors, status: :unprocessable_entity }
    end
  end
end

  def update
    if @task.update(task_params)
      redirect_to project_task_path(@project, @task), notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to project_tasks_path(@project), notice: 'Task was successfully destroyed.'
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

def task_params
  params.require(:task).permit(:title, :description, :status, :priority, :deadline)
end
end