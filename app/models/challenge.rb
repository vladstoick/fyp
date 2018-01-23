class Challenge < ApplicationRecord
  validates_presence_of :sql_schema, :sql_correct_query, :sql_seed
  validate :compile_sql

  private

  def compile_sql
    result = SqlAssess::Assesor.new.compile(
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
  end
end
