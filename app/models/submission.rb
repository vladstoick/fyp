class Submission < ApplicationRecord
  validates_presence_of :sql_query

  belongs_to :challenge, class_name: "Challenge"
  belongs_to :user, class_name: "User"

  validate :compile_sql

  private

  def compile_sql
    result = SqlAssess::Assesor.new.assess(
      create_schema_sql_query: challenge.sql_schema,
      instructor_sql_query: challenge.sql_correct_query,
      seed_sql_query: challenge.sql_seed,
      student_sql_query: sql_query
    )

    self.metadata = result.attributes
    self.success = result.success
    self.grade = result.grade
    self.attribute_grades = result.attributes_grade
    self.message = result.message
  rescue SqlAssess::DatabaseQueryExecutionFailed => exception
    errors.add(:sql_query, exception.message)
  end
end
