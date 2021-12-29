# frozen_string_literal: true

class RemoveColumnsFromExpenses < ActiveRecord::Migration[6.1]
  def change
    remove_column :expenses, :person_id
    remove_column :expenses, :people_id
    remove_column :expenses, :created_at
    remove_column :expenses, :updated_at
  end
end
