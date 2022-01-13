# frozen_string_literal: true

class AddSummToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :summ, :float
  end
end
