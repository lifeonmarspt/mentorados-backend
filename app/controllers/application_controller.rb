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
    accept = (request.headers["Accept-Language"] || "").first(2).to_sym
    locale = I18n.available_locales.find(I18n.default_locale){ |l| l == accept }

    I18n.locale = locale
  end
end
