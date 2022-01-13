# frozen_string_literal: true

class Communications < ActiveRecord::Migration[6.1]
  def change
    create_table :Communications do |t|
      t.integer :person_id
      t.integer :category_id
    end
  end
end
