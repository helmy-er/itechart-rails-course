# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(_resource)
    people_path
  end
  unless config.consider_all_requests_local
    rescue_from ActiveRecord::RecordNotFound, NoMethodError, with: :render_not_found
  end
end
