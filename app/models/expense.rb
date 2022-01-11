# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :category
  validates :name, presence: true
  validates :time, presence: true
  validates :summ, presence: true
end
