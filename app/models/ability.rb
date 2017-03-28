class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: "guest")

    if user.admin?
      can :manage, Country
      can :manage, Territory
      can :manage, LocalAuthorityEng
      can :manage, LocalAuthorityType
      can :manage, User
    elsif user.standard?
      can :manage, Country, user_id: user.id
      can :manage, Territory, user_id: user.id
      can :manage, LocalAuthorityEng, user_id: user.id
      can :manage, LocalAuthorityType, user_id: user.id
      can :manage, User, id: user.id
    end

    can :read, Country
    can :read, Territory
    can :read, LocalAuthorityEng
    can :read, LocalAuthorityType
  end
end
