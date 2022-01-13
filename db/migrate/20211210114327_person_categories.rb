# frozen_string_literal: true

class PersonCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :PersonCategories do |t|
      t.integer :person_id
      t.integer :category_id
    end
  end
end
