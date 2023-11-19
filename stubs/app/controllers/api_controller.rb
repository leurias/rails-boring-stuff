# frozen_string_literal: true

class ApiController < ApplicationController
  include ApiResponders

  prepend_before_action :authenticate_user!
end
