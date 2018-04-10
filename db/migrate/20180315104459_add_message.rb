# frozen_string_literal: true

class AddMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :message, :string
  end
end
