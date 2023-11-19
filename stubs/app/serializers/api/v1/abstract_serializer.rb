# frozen_string_literal: true

module Api
  module V1
    class AbstractSerializer
      include Alba::Resource

      root_key :data
    end
  end
end
