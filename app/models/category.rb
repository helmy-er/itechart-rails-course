# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :buffers
  has_many :people, through: :buffers
  has_many :expenses
end
