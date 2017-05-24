class CareersController < ApplicationController
  def index
    careers = Career.all
    render json: careers.as_json(only: [:id, :description])
  end
end
