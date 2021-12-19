# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :user
  has_many :buffers
  has_many :categories, through: :buffers
end
