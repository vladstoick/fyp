# frozen_string_literal: true

class AddAttributeGrading < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :attribute_grades, :json, null: false
  end
end
