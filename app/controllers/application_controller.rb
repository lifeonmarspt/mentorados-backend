class ApplicationController < ActionController::Base
  include Pundit
  include Knock::Authenticable

  before_action :set_locale
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

  def set_locale
    wanted = (request.headers["Accept-Language"] || "en")[0..1].to_sym
    locale = I18n.available_locales.include?(wanted) ? wanted : I18n.default_locale

    I18n.locale = locale
  end
end
