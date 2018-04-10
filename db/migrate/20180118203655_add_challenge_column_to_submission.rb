# frozen_string_literal: true

class AddChallengeColumnToSubmission < ActiveRecord::Migration[5.1]
  def change
    add_reference :submissions, :challenge
  end
end
