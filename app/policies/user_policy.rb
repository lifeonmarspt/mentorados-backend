class UserPolicy
  attr_reader :user, :subject_user

  # both user and subject_user are instances of the User model.
  # user refers to the User instance that is returned by current_user
  # subject_user refers to the User instance that is being checked for access authorization
  def initialize(user, subject_user)
    @user = user
    @subject_user = subject_user
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    @user.admin
  end

  def destroy?
    @user.admin && @user.id != @subject_user.id
  end
end
