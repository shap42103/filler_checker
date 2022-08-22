FactoryBot.define do
  factory :theme do
    title { '話題' }

    trait :blank_title do
      title { nil }
    end
  end
end
