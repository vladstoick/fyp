# frozen_string_literal: true

class AddGradeToSubmission < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :grade, :double
  end
end
