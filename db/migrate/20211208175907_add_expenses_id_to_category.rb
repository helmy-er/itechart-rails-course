# frozen_string_literal: true

class AddExpensesIdToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :expenses_id, :int
  end
end
