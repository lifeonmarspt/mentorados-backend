class MentorPolicy
  attr_reader :mentor, :subject

  # both mentor and subject are instances of the Mentor model.
  # mentor refers to the Mentor instance that is returned by current_mentor
  # subject refers to the Mentor instance that is being checked for access authorization
  def initialize(mentor, subject)
    @mentor = mentor
    @subject = subject
  end

  def destroy?
    @mentor.admin
  end

  def update?
    @mentor.admin or @mentor.id == @subject.id
  end

  def create?
    @mentor.admin
  end
end
