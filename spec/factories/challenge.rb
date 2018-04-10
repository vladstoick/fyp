FactoryBot.define do
  factory :challenge, class: 'Challenge' do
    user
    sequence(:title) { |n| "Challenge #{n}" }
    sequence(:content) { |n| "Content for challenge #{n}" }
    sql_schema "CREATE TABLE t1(id integer)"
    sql_seed "INSERT INTO t1(id) VALUES (1)"
    sql_correct_query "SELECT * FROM t1"
  end
end
