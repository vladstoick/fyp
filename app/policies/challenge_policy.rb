# frozen_string_literal: true

class ChallengePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    super && user.admin?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
