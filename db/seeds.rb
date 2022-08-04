# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

satoka = User.new(
  first_name: "Satoka",
  last_name: "Satome",
  relationship: "Granddaughter",
  phone_number: "090-2345-8569",
  email: "satoka@mail.me",
  password: "123456"
)
satoka.save!

jennifer = User.new(
  first_name: "Jennifer",
  last_name: "Nakayama",
  relationship: "Granddaughter",
  phone_number: "070-1234-3068",
  email: "satoka@mail.me",
  password: "654321"
)
jennifer.save!

antonio = User.new(
  first_name: "Antonio",
  last_name: "Jurado",
  relationship: "Grandson",
  phone_number: "080-2345-9868",
  email: "satoka@mail.me",
  password: "456789"
)
antonio.save!

zach = User.new(
  first_name: "Zach",
  last_name: "Carter",
  relationship: "Grandson",
  phone_number: "090-9355-2345",
  email: "satoka@mail.me",
  password: "987654"
)
zach.save!

10.times do
  chosen_user = [satoka, jennifer, zach, antonio].sample
  notification = Notification.new(
    user_id: chosen_user,
    accessed_at: Faker::Date.between(from: '2022-08-04', to: '2022-09-03'),
    description: Faker::Lorem.paragraph,
    read: Faker::Boolean.boolean,
    created_at: Faker::Date.between(from: '2022-08-04', to: '2022-09-03'),
    updated_at: Faker::Date.between(from: '2022-08-04', to: '2022-09-03')
  )
  notification.save!

  site = Site.new(
    blocked: Faker::Boolean.boolean,
    trust_with_popup: Faker::Boolean.boolean,
    user_id: chosen_user,
    notification_id: [],
    reason: Faker::Lorem.sentence,
    url: Faker::Internet.url,
    referral_site: Faker::Internet.url
  )
  site.save!
end
