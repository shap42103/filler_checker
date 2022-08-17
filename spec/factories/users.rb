FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "general-#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    role { :general }

    trait :admin do
      sequence(:name) { |n| "admin-#{n}" }
      role { :admin }
    end
  end
end
