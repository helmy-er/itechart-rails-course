# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.integer :people_id
      t.integer :expense_id
      t.timestamps
    end
  end
end
