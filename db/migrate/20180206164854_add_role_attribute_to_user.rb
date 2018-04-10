# frozen_string_literal: true

class AddRoleAttributeToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :string, default: 'student', null: false
  end
end
