FactoryBot.define do
  factory :submission, class: 'Submission' do
    user
    challenge
    sql_query "SELECT * FROM t1"
    grade 55
  end
end
