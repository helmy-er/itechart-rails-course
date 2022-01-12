# frozen_string_literal: true

class Person < ApplicationRecord
  belongs_to :user
  has_many :buffers
  has_many :categories, through: :buffers
  validates :name, presence: true
  validates :name, length: { maximum: 10 }
end
