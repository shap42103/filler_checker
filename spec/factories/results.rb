FactoryBot.define do
  factory :result do
    filler_count { 5 }
    most_frequent_filler { '%えーと%' }
    
    trait :zero_filler_count do
      filler_count { 0 }
      most_frequent_filler { nil }
    end
  end
end
