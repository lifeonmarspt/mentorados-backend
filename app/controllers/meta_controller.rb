class MetaController < ApplicationController
  def index
    authorize :meta

    render json: {
      genders: [
        { id: "A", description: "All" },
        { id: "F", description: "Female" },
        { id: "M", description: "Male" },
      ],

      careers: Career.all.as_json(only: [:id, :description]),
    }
  end
end
