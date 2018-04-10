# frozen_string_literal: true

class AddChallenge < ActiveRecord::Migration[5.1]
  def change
    create_table :challenges do |t|
      t.string :title
      t.references :user
      t.timestamps
    end
  end
end
