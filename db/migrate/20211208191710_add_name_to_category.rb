# frozen_string_literal: true

class AddNameToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :name, :string
  end
end
