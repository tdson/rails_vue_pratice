10.times.each do
  time = rand(1..50_000).minutes.ago
  Task.create! title: Faker::Lorem.sentence, created_at: time, updated_at: time
end
