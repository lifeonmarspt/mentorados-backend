class CareersController < ApplicationController

  def index
    careers = Career.all.to_json
    render json: careers
  end

end
