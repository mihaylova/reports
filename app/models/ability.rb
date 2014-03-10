class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
       user ||= User.new # guest user (not logged in)
       alias_action :create, :read, :update, :destroy, :to => :crud
       can :read, :all

      if user.editor?
        can :create, :all
        can :read, :all
        can :update, Report, permissions: {editor_can_edit: true}
        can :destroy, Report, permissions: {editor_can_delete: true}
        can :update, Report, permissions: {author_can_edit: true}, user_id: user.id
        can :destroy, Report, permissions: {author_can_delete: true}, user_id: user.id
      else
        can :create, :all
        can :read, :all
        can :update, Report, permissions: {author_can_edit: true}, user_id: user.id
        can :destroy, Report, permissions: {author_can_delete: true}, user_id: user.id
      end

      #  if user.new_record?
      #   can :read, :all
      # elsif user.editor?
      #   can :manage, :all
      # else
      #   can :manage, Report, user_id: user.id
      #   can :read, :all
      # end
        
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
