class Api::TasksController < ApplicationController
  before_action :find_task, except: [:index, :create]

  def index
    @tasks = Task.all
  end

  def show
  end

  def create
    @task = Task.create task_params
  end

  def update
    @task.update_attributes task_params
  end

  def destroy
    @task.destroy
  end

  private
  def find_task
    @task = Task.find_by id: params[:id]
    render_404 unless @task
  end

  def task_params
    params.require(:task).permit :title, :is_done
  end
end
