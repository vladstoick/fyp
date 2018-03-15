class AddForeignKey < ActiveRecord::Migration[5.1]
  def change
    change_column :challenges, :user_id, :bigint
    add_foreign_key :challenges, :users

    change_column :submissions, :challenge_id, :bigint
    add_foreign_key :submissions, :challenges

    change_column :submissions, :user_id, :bigint
    add_foreign_key :submissions, :users
  end
end
