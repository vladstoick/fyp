FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:email) { |n| "person#{n}@example.com" }
    password "password"
  end
end
