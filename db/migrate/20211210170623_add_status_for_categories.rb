# frozen_string_literal: true

class AddStatusForCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :status, :boolean
  end
end
