# frozen_string_literal: true

class AddPerosnIdToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :person_id, :int
  end
end
