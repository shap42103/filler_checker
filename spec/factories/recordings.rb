FactoryBot.define do
  factory :recording do
    # 1種のフィラーのみのとき
    voice { 'recording' }
    text { }
    length { 60 }

    trait :blank_voice do
      voice { nil }
    end

    trait :blank_text do
      text { nil }
    end

    trait :blank_length do
      length { nil }
    end
  end
end
