FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "general-#{n}" }
    email { "test@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    role { :general }
    
    trait :admin do
      sequence(:name) { |n| "admin-#{n}" }
      role { :admin }
    end
    
    trait :other_user do
      email { "test02@example.com" }
      name { "other_user" }
    end

    trait :blank_name do
      name { nil }
    end

    trait :blank_email do
      email { nil }
    end

    trait :blank_password do
      password { nil }
    end

    trait :duplicated_email do
      email { "test@example.com" }
    end
    
    trait :unmatch_password_confirmation do
      password_confirmation { '12345678' }
    end

  end
end
