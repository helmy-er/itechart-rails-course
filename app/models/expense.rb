# frozen_string_literal: true

class Expense < ApplicationRecord
  belongs_to :category
  validates :name, presence: true
  validates :time, presence: true
  validates :summ, presence: true
  validates :name, length: { maximum: 40 }
  validates_date :time, on_or_before: :today, type: :date
end
