class MentorPolicy
  attr_reader :user, :mentor

  def initialize(user, mentor)
    @user = user
    @mentor = mentor
  end

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
    @user.admin || @user.id == @mentor.user_id
  end

  def destroy?
    @user.admin
  end
end
