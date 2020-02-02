# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Starting fresh
User.delete_all
Post.delete_all
Comment.delete_all
Like.delete_all
# Creates 10 random generated users with posts
50.times do
  pass = Faker::Internet.password(min_length: 6)

  user = User.create(
    email: Faker::Internet.unique.free_email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.cell_phone_with_country_code,
    gender: Faker::Gender.binary_type,
    birthday: Faker::Date.birthday,
    password: pass,
    password_confirmation: pass
  )

  rand(5).times do
    post = user.posts.create(
      title: Faker::Book.unique.title,
      content: Faker::Lorem.paragraph_by_chars(number: rand(89) + 311) + "\n\n" + Faker::Lorem.paragraph_by_chars(number: rand(73) + 429)
    )

    post.update(created_at: Faker::Time.between(from: DateTime.now - 30, to: DateTime.now))
  end
end

User.all.each do |u|
  Post.all.each do |p|
    if rand(2) == 1
      p.likers << u
    end

    if rand(2) == 1
      p.comments.create(body: Faker::Lorem.paragraph, commenter_id: u.id)
    end
  end
end
