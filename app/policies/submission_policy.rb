class SubmissionPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    true
  end
end
