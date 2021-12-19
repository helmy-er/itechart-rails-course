# frozen_string_literal: true

class AddPersonIdToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :person_id, :int
  end
end
