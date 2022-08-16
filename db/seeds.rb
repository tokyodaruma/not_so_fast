require 'faker'
require 'json'
require 'open-uri'

puts "clearing seeds"

CareReceiver.destroy_all
Site.destroy_all
Notification.destroy_all
User.destroy_all

puts "replanting seeds"

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
  email: "test@mail.me",
  password: "654321"
)
jennifer.save!

antonio = User.new(
  first_name: "Antonio",
  last_name: "Jurado",
  relationship: "Grandson",
  phone_number: "080-2345-9868",
  email: "test@test.me",
  password: "456789"
)
antonio.save!

zach = User.new(
  first_name: "Zach",
  last_name: "Carter",
  relationship: "Grandson",
  phone_number: "090-9355-2345",
  email: "fake@fake.me",
  password: "987654"
)
zach.save!

puts "#{satoka.first_name}, #{jennifer.first_name}, #{antonio.first_name}, #{zach.first_name} made."

puts "Creating Carereceivers"
  satoka_grandma = CareReceiver.new(
    first_name: "Grandma",
    last_name: "Satome",
    chrome_id: "123456",
    relationship: "Grandma",
    user_id: satoka.id
  )
  satoka_grandma.save!

  jennifer_grandma = CareReceiver.new(
    first_name: "Grandma",
    last_name: "Nakayama",
    chrome_id: "123457",
    relationship: "Grandma",
    user_id: jennifer.id
  )
  jennifer_grandma.save! # .save  should it ends with ! <= ??

  antonio_grandma = CareReceiver.new(
    first_name: "Grandma",
    last_name: "Jurado",
    chrome_id: "123458",
    relationship: "Grandma",
    user_id: antonio.id
  )
  antonio_grandma.save!

  zach_grandma = CareReceiver.new(
    first_name: "Grandma",
    last_name: "Carter",
    chrome_id: "123459",
    relationship: "Grandma",
    user_id: zach.id
  )
  zach_grandma.save!

scam_url = 'https://fastspecialists.info/oop/9989_md/10/221/3591/17/5316583'
api_key = ENV['APIVOID_KEY']
request = "https://endpoint.apivoid.com/urlrep/v1/pay-as-you-go/?key=#{api_key}&url=#{scam_url}"
risk_results_serialized = URI.parse(request).open.read
results = JSON.parse(risk_results_serialized)

p results
500.times do
  chosen_user = [satoka, jennifer, zach, antonio].sample
  notification = Notification.new(
    user_id: chosen_user.id,
    accessed_at: Faker::Date.between(from: '2022-08-04', to: '2022-09-03'),
    # results.dig("data", "report", "response_headers", "date") ||
    description: Faker::Lorem.paragraph,
    read: Faker::Boolean.boolean,
    created_at: Faker::Date.between(from: '2022-08-04', to: '2022-09-03'),
    updated_at: Faker::Date.between(from: '2022-08-04', to: '2022-09-03')
  )
  notification.save!

  site = Site.new(
    blocked: false,
    trust_with_popup: false,
    user_id: chosen_user.id,
    notification: notification,
    reason: Faker::Lorem.sentence,
    url: Faker::Internet.url,
    referral_site: Faker::Internet.url,
    detections: results["data"]["report"]["domain_blacklist"]["detections"],
    risk_score: results["data"]["report"]["risk_score"]["result"]
  )
  site.save!

  puts "Notification ##{notification.id} and Site ##{site.id} made."
end
