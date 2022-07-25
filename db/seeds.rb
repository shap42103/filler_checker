10.times do
  User.create(
      name: Faker::Name.first_name,
      email: Faker::Internet.email,
      password: '12345678',
      password_confirmation: '12345678'
  )
end

20.times do
  Theme.create(
      title: Faker::Movie.title
  )
end

20.times do |index|
  Recording.create(
      user: User.offset(rand(User.count)).first,
      theme: Theme.offset(rand(Theme.count)).first,
      voice: "voice-#{index}",
      text: Faker::Movie.quote,
      length: rand(180)
  )
end

20.times do |index|
 Result.create(
      recording: Recording.offset(rand(Recording.count)).first,
      filler_count: rand(1..10),
      most_frequent_filler: Faker::Food.fruits
    )
  end
  
  50.times do |index|
    TextAnalysis.create(
      recording: Recording.offset(rand(Recording.count)).first,
      word: Faker::Food.fruits,
      filler: Faker::Boolean.boolean
  )
end
