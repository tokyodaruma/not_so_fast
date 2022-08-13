class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def update?
    record.user == user
  end

  def create?
    true
  end
end
