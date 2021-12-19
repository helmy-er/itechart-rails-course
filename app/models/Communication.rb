# frozen_string_literal: true

class Communication < ApplicationRecord
  belongs_to :people
  belongs_to :category
end
