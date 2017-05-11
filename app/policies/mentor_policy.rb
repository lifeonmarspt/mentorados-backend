class MentorPolicy
  attr_reader :user, :mentor

  def initialize(user, mentor)
    @user = user
    @mentor = mentor
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    @user.admin
  end

  def update?
    @user.admin or @user.id == @mentor.user_id
  end

  def destroy?
    @user.admin
  end
end
