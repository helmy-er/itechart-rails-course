# frozen_string_literal: true

class Buffer < ApplicationRecord
  belongs_to :person
  belongs_to :category
end
