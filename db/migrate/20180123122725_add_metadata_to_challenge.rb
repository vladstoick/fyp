# frozen_string_literal: true

class AddMetadataToChallenge < ActiveRecord::Migration[5.1]
  def change
    add_column :challenges, :metadata, :json
  end
end
