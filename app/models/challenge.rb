# frozen_string_literal: true

class Challenge < ApplicationRecord
  validates_presence_of :sql_schema, :sql_correct_query, :sql_seed, :title, :content
  validate :compile_sql

  has_many :submissions, class_name: 'Submission', dependent: :destroy
  belongs_to :user, class_name: 'User'

  def best_submissions
    submissions.select('max(grade) as max_grade, user_id').group(:user_id)
  end

  private

  def compile_sql
    return unless sql_schema.present? && sql_correct_query.present? && sql_seed.present?
    result = SharedAssesor.assesor.compile(
      create_schema_sql_query: sql_schema,
      instructor_sql_query: sql_correct_query,
      seed_sql_query: sql_seed
    )
    self.metadata = result
  rescue SqlAssess::DatabaseSchemaError => exception
    errors.add(:sql_schema, exception.message)
  rescue SqlAssess::DatabaseSeedError => exception
    errors.add(:sql_seed, exception.message)
  rescue SqlAssess::DatabaseQueryExecutionFailed => exception
    errors.add(:sql_correct_query, exception.message)
  rescue SqlAssess::CanonicalizationError
    errors.add(:sql_correct_query, 'Cannot canonicalize query')
  end
end
