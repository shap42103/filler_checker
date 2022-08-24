FactoryBot.define do
  factory :text_analysis do
    word { '%えーと%' }
    filler { true }
    recording

    trait :not_filler do
      word { 'てすと' }
      filler { false }
    end

    trait :blank_filler do
      word { 'てすと' }
      filler { nil }
    end
    
    trait :blank_word do
      word { nil }
      filler { false }
    end
  end
end
