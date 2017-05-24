class ApplicationController < ActionController::Base
  include Pundit
  include Knock::Authenticable

  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized

  private
  def unauthorized
    head :unauthorized
  end
end
