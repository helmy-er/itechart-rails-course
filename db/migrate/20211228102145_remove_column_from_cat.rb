class RemoveColumnFromCat < ActiveRecord::Migration[6.1]
  def change
    remove_column :categories, :people_id
    remove_column :categories, :expense_id
    remove_column :categories, :person_id
    remove_column :categories, :expenses_id
    remove_column :categories, :created_at
    remove_column :categories, :updated_at
  end
end
