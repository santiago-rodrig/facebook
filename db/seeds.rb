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
10.times do
  pass = Faker::Internet.password(min_length: 6)

  user = User.create(
    email: Faker::Internet.unique.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.cell_phone_with_country_code
    gender: Faker::Gender.binary_type
    birthday: Faker::Date.birthday
    password: pass,
    password_confirmation: pass
  )

  rand(10).times do
    user.posts.create(
      title: Faker::Books.unique.title,
      content: Faker::Lorem.paragraphs(number: rand(10) + 1)
    )
  end
end

User.all.each do |u|
  rand(5).times do
    u.comments.create(body: Faker::Lorem.paragraph, commented_post_id: rand(Post.count) + 1)
  end

  Post.all.each do |p|
    if rand(2) == 1
      p.likers << u
    end
  end
end
