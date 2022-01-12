# frozen_string_literal: true

class AddForAllCheckerToCat < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :for_all, :boolean
  end
end
