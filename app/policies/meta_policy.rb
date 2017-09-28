class MetaPolicy < ApplicationPolicy
  def index?
    @user
  end
end
