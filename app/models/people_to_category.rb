# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :people
  has_many :expenses
end
