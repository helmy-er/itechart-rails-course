# frozen_string_literal: true

class AddTimeToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :time, :date
  end
end
