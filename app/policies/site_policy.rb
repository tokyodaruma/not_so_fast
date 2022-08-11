class SitePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def create?
    true
  end

  # def edit?
  #   user == record.user
  # end

  def update?
    record.user == user
  end
end
