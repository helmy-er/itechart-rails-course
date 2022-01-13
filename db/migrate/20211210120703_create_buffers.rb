# frozen_string_literal: true

class CreateBuffers < ActiveRecord::Migration[6.1]
  def change
    create_table :buffers do |t|
      t.integer :person_id
      t.integer :category_id
    end
  end
end
