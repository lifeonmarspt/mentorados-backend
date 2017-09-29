module Requests
  module JsonHelpers
    def json
      json = JSON.parse(response.body)

      if json.is_a? Array
        json.map(&:with_indifferent_access)
      else
        json.with_indifferent_access
      end
    end
  end
end
