# frozen_string_literal: true

class AddFieldsToChallenge < ActiveRecord::Migration[5.1]
  def change
    add_column :challenges, :content, :text
    add_column :challenges, :sql_schema, :text
    add_column :challenges, :sql_seed, :text
  end
end
