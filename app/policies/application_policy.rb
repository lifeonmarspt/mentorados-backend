class ApplicationPolicy
  class Blocked < StandardError; end

  def initialize(user, record)
    raise Blocked if user&.blocked
    @user = user
    @record = record
  end
end
