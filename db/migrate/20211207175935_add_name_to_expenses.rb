# frozen_string_literal: true

class AddNameToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :name, :string
  end
end
