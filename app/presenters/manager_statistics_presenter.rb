class ManagerStatisticsPresenter < StatisticsPresenter

  def initialize
    @task_searcher = ManagerTESearcher.new
    @developers = User.developers
  end

  def total_hours
    Date.today.iteration.total_hours * @developers.count
  end

  def hours
    @hours ||= "#{total_hours} (#{Date.today.iteration.business_hours * @developers.count})"
  end

  def spent_hours
    tasks = @task_searcher.between(Date.today.iteration.beginning, Date.today.iteration.end)
    tasks.to_a.inject(0){ |s, t| s + t.duration }
  end

  def finished
    if hours.to_i == 0
      '0'
    else
      percentage = spent_hours / hours.to_f * 100
      percentage.nan? ? '0' : "#{spent_hours} (#{percentage.round}%)"
    end
  end

end