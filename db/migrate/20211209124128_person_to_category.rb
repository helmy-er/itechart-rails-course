# frozen_string_literal: true

class PersonToCategory < ActiveRecord::Migration[6.1]
  def change
    create_table :people_to_category do |t|
      t.integer :person_id
      t.integer :category_id
    end
  end
end
