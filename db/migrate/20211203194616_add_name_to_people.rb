class AddNameToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :name, :string
  end
end
