class SitePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def create?
    true
  end

  # def edit?
  #   user == record.user
  # end

  def call
    true
  end

  def update?
    record.user == user
  end
end
