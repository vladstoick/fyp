class CreateSubmission < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.timestamps
      t.text :sql_query
      t.boolean :success
    end
  end
end
