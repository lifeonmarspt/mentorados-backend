class MentorPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user
  end

  def create?
    @user.admin
  end

  def update?
    @user.admin || @user.id == @record.user_id
  end

  def destroy?
    @user.admin
  end
end
