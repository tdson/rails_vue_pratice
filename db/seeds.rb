10.times.each do
  Task.create! title: Faker::Lorem.sentence
end
