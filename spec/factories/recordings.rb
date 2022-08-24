recording_text = %Q[{"results":[{"tokens":[{"written":"%えーと%","confidence":0.45,"starttime":708,"endtime":1252,"spoken":"%えーと%"},{"written":"こんにちは","confidence":0.87,"starttime":1252,"endtime":2228,"spoken":"こんにちは"}],"confidence":0.993,"starttime":500,"endtime":2692,"tags":[],"rulename":"","text":"%えーと%こんにちは"}],"utteranceid":"20220816/ja_ja-amivoicecloud-16k-shap42103@0182a5acdadd0a3038ff8536-0816_170226","text":"%えーと%こんにちは","code":"","message":""}/-/-/{"results":[{"tokens":[{"written":"%あのー%","confidence":0.45,"starttime":708,"endtime":1252,"spoken":"%あのー%"},{"written":"こんばんは","confidence":0.87,"starttime":1252,"endtime":2228,"spoken":"こんばんは"}],"confidence":0.993,"starttime":500,"endtime":2692,"tags":[],"rulename":"","text":"%あのー%こんばんは"}],"utteranceid":"20220816/ja_ja-amivoicecloud-16k-shap42103@0182a5acdadd0a3038ff8536-0816_170226","text":"%あのー%こんばんは","code":"","message":""}]

FactoryBot.define do
  factory :recording do
    voice { 'recording' }
    text { recording_text }
    length { 60 }
    user
    theme

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
