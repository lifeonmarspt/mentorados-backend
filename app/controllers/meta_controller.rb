class MetaController < ApplicationController
  def index
    authorize :meta

    render json: {
      traits: Trait.all.as_json(only: [:id, :description]),
      careers: Career.all.as_json(only: [:id, :description]),
    }
  end
end
