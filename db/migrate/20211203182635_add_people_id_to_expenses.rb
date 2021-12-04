class AddPeopleIdToExpenses < ActiveRecord::Migration[6.1]
  def change
    add_column :expenses, :people_id, :int
  end
end
