class ApplicationController < ActionController::Base
  include Pundit
  include Knock::Authenticable
end
