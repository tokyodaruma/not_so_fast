require 'faker'
require 'json'
require 'open-uri'

puts "clearing seeds"

CareReceiver.destroy_all
Site.destroy_all
Notification.destroy_all
User.destroy_all

puts "replanting seeds"

# satoka = User.new(
#   first_name: "Satoka",
#   last_name: "Satome",
#   relationship: "Granddaughter",
#   phone_number: "090-2345-8569",
#   email: "satoka@mail.me",
#   password: "123456"
# )
# satoka.save!

# jennifer = User.new(
#   first_name: "Jennifer",
#   last_name: "Nakayama",
#   relationship: "Granddaughter",
#   phone_number: "070-1234-3068",
#   email: "test@mail.me",
#   password: "654321"
# )
# jennifer.save!

# antonio = User.new(
#   first_name: "Antonio",
#   last_name: "Jurado",
#   relationship: "Grandson",
#   phone_number: "080-2345-9868",
#   email: "test@test.me",
#   password: "456789"
# )
# antonio.save!

zach = User.new(
  first_name: "Zach",
  last_name: "Carter",
  relationship: "Grandson",
  phone_number: "090-9355-2345",
  email: "fake@fake.me",
  password: "987654"
)
zach.save!

puts "#{zach.first_name} made."

puts "Creating Carereceiver"
  # satoka_grandma = CareReceiver.new(
  #   first_name: "Grandma",
  #   last_name: "Satome",
  #   chrome_id: "123456",
  #   relationship: "Grandma",
  #   user_id: satoka.id
  # )
  # satoka_grandma.save!

  # jennifer_grandma = CareReceiver.new(
  #   first_name: "Grandma",
  #   last_name: "Nakayama",
  #   chrome_id: "123457",
  #   relationship: "Grandma",
  #   user_id: jennifer.id
  # )
  # jennifer_grandma.save! # .save  should it ends with ! <= ??

  # antonio_grandma = CareReceiver.new(
  #   first_name: "Grandma",
  #   last_name: "Jurado",
  #   chrome_id: "123458",
  #   relationship: "Grandma",
  #   user_id: antonio.id
  # )
  # antonio_grandma.save!

  zach_grandma = CareReceiver.new(
    first_name: "Grandma",
    last_name: "Carter",
    chrome_id: "123459",
    relationship: "Grandma",
    user_id: zach.id
  )
  zach_grandma.save!

suspicious_sites = [
  "https://posterbest.info/oop/21401_md/101/359/3613/38/150341",
  "https://girlscute.info/oop/21313_md/101/368/3591/38/150341",
  "https://duckstar.info/oop/21223_md/101/368/3591/38/150341",
  "https://cafewife.info/oop/21144_md/101/368/3591/38/150341",
  "https://littlepoof.info/oop/21074_md/101/368/3591/38/150341",
  "https://tangosave.info/oop/21027_md/101/368/3591/38/150341",
  "https://frogbaby.info/oop/20936_md/101/368/3591/38/150341"
]

suspicious_sites.each do |site|
  api_key = ENV['APIVOID_KEY']
  request = "https://endpoint.apivoid.com/urlrep/v1/pay-as-you-go/?key=#{api_key}&url=#{site}"
  risk_results_serialized = URI.parse(request).open.read
  results = JSON.parse(risk_results_serialized)

  notification = Notification.create!(
    user_id: zach.id,
    accessed_at: Faker::Date.between(from: '2022-08-22', to: '2022-08-27'),
    description: "#{results['data']['report']['domain_blacklist']['detections']} other site(s) flagged this as a risky URL",
    read: false
  )

  site = Site.create!(
    status: :pending,
    user_id: zach.id,
    notification: notification,
    reason: "#{results['data']['report']['domain_blacklist']['detections']} other site(s) flagged this as a risky URL",
    url: site,
    referral_site: Faker::Internet.domain_name,
    detections: results["data"]["report"]["domain_blacklist"]["detections"],
    risk_score: results["data"]["report"]["risk_score"]["result"],
    is_domain_recent: results["data"]["report"]["security_checks"]["is_domain_recent"],
    webpage_title: results["data"]["report"]["web_page"]["title"]
  )

  puts "Notification ##{notification.id} and Site ##{site.id} made."
end
