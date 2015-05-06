class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.chief?
      can :manage, :all
      cannot :create, RelatedTask
      cannot :create, TimeEntry
    end

    if user.developer?
      can :read, User
      cannot :read, User, position: 'nobody'
      can :read, Project, id: user.project_ids
      can :manage, Comment, form: 'developer', project: { id: user.project_ids }
      can :read, Comment, form: 'general', project: { id: user.project_ids }
      can :manage, RelatedTask, user_id: user.id
      can :manage, TimeEntry, related_task: { id: user.related_task_ids }
      can :manage, Article, user_id: user.id
      can [:read, :unread], Article
    end

    if user.manager?
      can :read, User
      cannot :read, User, position: 'nobody'
      can :manage, Project, id: user.project_ids
      can :create, Project
      can :manage, ProjectPresenter
      can :manage, Comment, project: { id: user.project_ids }
      can :manage, RelatedTask, user_id: user.id
      can :read, RelatedTask, project: { id: user.project_ids }
      can :manage, TimeEntry, related_task: { id: user.related_task_ids }
      can :read, Customer
      can :read, Contact
      can :manage, Article, user_id: user.id
      can [:read, :unread], Article
    end

    if user.hr? || user.buh?
      can :read, User
      cannot :read, User, position: 'nobody'
      can :manage, Customer
      can :read, Contact
      can :manage, Article, user_id: user.id
      can [:read, :unread], Article
    end

    if user.teamleader?
      can :read, User
      cannot :read, User, position: 'nobody'
      can :read, Project, id: user.project_ids
      can :manage, Comment, form: 'developer', project: { id: user.project_ids }
      can :manage, Comment, form: 'general', project: { id: user.project_ids }
      can :manage, RelatedTask, project: { id: user.project_ids }
      can :manage, RelatedTask, user_id: user.id
      can :manage, TimeEntry, related_task: { id: user.related_task_ids }
      can :read, Customer
      can :read, Contact
      can :manage, Article, user_id: user.id
      can [:read, :unread], Article
    end

    if user.customer?
      can :read, Project, id: user.project_ids
      can :read, RelatedTask, project: { id: user.project_ids }
      can :read, Customer, projects: { id: user.project_ids }
      can :read, Contact, customer: { projects: { id: user.project_ids } }
      can [:read, :unread], Article
    end

    if user.saler?
      can :read, User
      cannot :read, User, position: 'nobody'
      can :read, Project, id: user.project_ids
      can :manage, Customer
      can :manage, Contact
      can [:read, :unread], Article
    end
  end
end
