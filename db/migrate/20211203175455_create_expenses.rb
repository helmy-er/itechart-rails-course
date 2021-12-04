class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.string :text
      t.boolean :status
      t.timestamps
    end
  end
end
