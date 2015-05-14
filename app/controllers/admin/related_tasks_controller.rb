class Admin::RelatedTasksController < Admin::AdminController
  load_and_authorize_resource
  inject :related_task_manager
  inject :related_task_searcher

  before_filter :prepare_gon, only: [:new, :edit]

  def index
    @search = RelatedTaskSearchForm.new(params[:search])
    @projects = Project.all.map{ |p| [p.name, p.id] }
    @related_tasks = related_task_searcher.find_by_form(@search).includes(:project, :time_entries).order('date DESC, created_at').paginate(page: params[:page], per_page: 20)
  end

  def new

  end

  def create
    related_task_manager.create(related_task_params) do |task, saved|
      if saved
        render json: task
      else
        render json: task.errors.messages, status: 422
      end
    end
  end

  def edit

  end

  def update
    related_task = RelatedTask.find(params[:id])
    related_task_manager.update(related_task, related_task_params) do |task, saved|
      if saved
        render json: task
      else
        render json: task.errors.messages, status: 422
      end
    end
  end

  def destroy
    related_task_manager.destroy(@related_task)
    redirect_to admin_related_tasks_path
  end

  def find
    related_tasks = related_task_searcher.find(params)
    render json: related_tasks
  end

  protected

  def related_task_params
    RelatedTaskPermitter.permit(params)
  end

  def prepare_gon
    gon.related_task = @related_task.present? ? RelatedTaskPresenter.new(@related_task).to_hash : nil
    gon.projects = current_user.projects
    gon.role = current_user.position
    gon.statuses = RelatedTask.statuses_i18n.map{ |k,v| { id: k, name: v } }
    gon.task_types = RelatedTask.task_types_i18n.map{ |k,v| { id: k, name: v } }
  end
end
