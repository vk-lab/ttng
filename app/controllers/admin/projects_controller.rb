class Admin::ProjectsController < Admin::AdminController
  load_and_authorize_resource except: [:create, :update]
  inject :admin_project_manager
  inject :google_exporter

  before_filter :prepare_gon, only: [:new, :edit]
  before_filter :find_tasks, only: [:show, :to_google_drive]

  def index
    @projects = ProjectPresenter.map(@projects.includes(:customer, :users, :related_tasks, :features, :bugs, :chores)).paginate(page: params[:page], per_page: 5)
  end

  def new

  end

  def create
    authorize! :create, Project
    admin_project_manager.create(project_params) do |project, saved|
      if saved
        render json: project
      else
        render json: project.errors.messages, status: 422
      end
    end
  end

  def show
    @filter = RelatedTaskSearchForm.new(params[:filter])
    respond_to do |format|
      format.html
      format.xlsx do
        render xlsx: 'show', filename: @project.name
      end
    end
  end

  def edit

  end

  def update
    @project = Project.find(params[:id])
    authorize! :update, @project
    admin_project_manager.update(@project, project_params) do |project, saved|
      if saved
        render json: project
      else
        render json: project.errors.messages, status: 422
      end
    end
  end

  def destroy
    admin_project_manager.destroy(@project)
    redirect_to admin_projects_path
  end

  def export
    session[:export_project_id] = @project.id
    session[:export_project_from] = params[:from]
    session[:export_project_to] = params[:to]

    redirect_to '/auth/google_oauth2'
  end

  def to_google_drive

    string = render_to_string(template: 'admin/projects/show.xlsx.axlsx')
    google_exporter.upload_file(project: @project, content: string)
    redirect_to admin_project_path(@project.id)
  end

  private

  def project_params
    ProjectPermitter.permit(params)
  end

  def prepare_gon
    gon.project = @project.present? ? ProjectPresenter.new(@project).to_hash : nil
    gon.customers = Customer.all
    gon.users = UserPresenter.map(User.all)
  end

  def find_tasks
    @related_tasks = @project.related_tasks.order('date DESC').includes(:user, :time_entries)
    @from = session[:export_project_from].presence || params[:from]
    @to = session[:export_project_to].presence || params[:to]

    session.delete :export_project_from
    session.delete :export_project_to

    if @from.present?
      @from = Date.strptime(@from, '%d.%m.%Y')
      @related_tasks = @related_tasks.where('date >= ?', @from)
    end

    if @to.present?
      @to = Date.strptime(@to, '%d.%m.%Y')
      @related_tasks = @related_tasks.where('date <= ?', @to)
    end
  end

end
