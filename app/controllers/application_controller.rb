class ApplicationController < ActionController::Base
  include Pundit
  include Knock::Authenticable

  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized
  rescue_from ApplicationPolicy::Blocked, with: :blocked

  private
  def unauthorized
    head :unauthorized
  end

  def blocked
    head :forbidden
  end
end
