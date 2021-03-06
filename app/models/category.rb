# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :buffers
  has_many :people, through: :buffers
  has_many :expenses
  validates :name, presence: true
  validates :name, length: { maximum: 10 }
end
