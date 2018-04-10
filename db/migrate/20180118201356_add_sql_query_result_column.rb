# frozen_string_literal: true

class AddSqlQueryResultColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :challenges, :sql_correct_query, :text
  end
end
