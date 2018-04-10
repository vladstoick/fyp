# frozen_string_literal: true

class AddMetadataToSubmission < ActiveRecord::Migration[5.1]
  def change
    add_column :submissions, :metadata, :json
  end
end
