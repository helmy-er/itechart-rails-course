class AddUserIdToPeople < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :user_id, :int
  end
end
