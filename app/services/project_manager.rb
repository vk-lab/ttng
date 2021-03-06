class ProjectManager < ResourceManager::Base
  inject :current_user
  model Project

  before_create do |params|
    params[:users] << {id: current_user.id}
    @users = params.delete(:users)
  end

  before_update do |_, params|
    @users = params.delete(:users)
  end

  after_create do |project|
    update_users(project)
  end

  after_update do |project|
    update_users(project)
  end

  private

  def update_users(project)
    project.project_users.destroy_all

    if @users.present?
      project.users = User.where('id IN (?)', @users.map{ |u| u[:id]} )
    end
  end
end