# frozen_string_literal: true

json.extract! buffer, :id, :created_at, :updated_at
json.url buffer_url(buffer, format: :json)
