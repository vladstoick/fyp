class AddUserIdToSubmission < ActiveRecord::Migration[5.1]
  def change
    add_reference :submissions, :user
  end
end
