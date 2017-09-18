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
    @user && @user.admin
  end

  def mentors?
    @user
  end

  def create?
    !@user
  end

  def show?
    @user && (@user.admin || @user.id == @subject_user.id)
  end

  def update?
    @user && (@user.admin || @user.id == @subject_user.id)
  end

  def permitted_attributes
    attributes = [:password]

    attributes += [:name, :bio, :year_in, :year_out, :picture_url, :location, :active, links: [], career_ids: []] if subject_user.mentor
    attributes += [:email] if user.admin || subject_user.mentor

    attributes += [:blocked] if user.admin

    attributes
  end
end
