# frozen_string_literal: true

class SubmissionPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    true
  end

  def report?
    user.admin?
  end

  def show?
    super && (user.admin? || record.user == user)
  end
end
