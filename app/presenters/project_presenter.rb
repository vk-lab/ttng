class ProjectPresenter < Presenter
  expose_all

  def real_time
    total_time_for(related_tasks.to_a)
  end

  def bug_time
    total_time_for(bugs.to_a)
  end

  def task_time
    total_time_for(features.to_a)
  end

  def chore_time
    total_time_for(chores.to_a)
  end

  def real_time_by(user)
    total_time_for(related_tasks.where(user_id: user.id).to_a)
  end

  def bug_time_by(user)
    total_time_for(bugs.where(user_id: user.id).to_a)
  end

  def feature_time_by(user)
    total_time_for(features.where(user_id: user.id).to_a)
  end

  def chore_time_by(user)
    total_time_for(chores.where(user_id: user.id).to_a)
  end

  def to_hash
    {
        id: id,
        name: name,
        rate: rate.to_f,
        description: description,
        customer: customer,
        pivotal_id: pivotal_id,
        users: users.map{ |u| {user: UserPresenter.new(u).to_hash } }
    }
  end

  private

  def total_time_for(tasks)
    tasks.inject(0) do |sum, task|
      sum + task.real_time
    end
  end


end