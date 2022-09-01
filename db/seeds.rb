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

suspicious_sites_redirect_from_email = [
  "https://posterbest.info/oop/21401_md/101/359/3613/38/150341",
  "https://duckstar.info/oop/21223_md/101/368/3591/38/150341",
  "https://littlepoof.info/oop/21074_md/101/368/3591/38/150341",
  "https://tangosave.info/oop/21027_md/101/368/3591/38/150341",
  "https://frogbaby.info/oop/20936_md/101/368/3591/38/150341"
]

suspicious_sites_lotto = [
  "https://molottery.com/",
  "https://powerballl.com/",
  "http://www.sports-buzz-blog.com",
  "http://www.highperformancegate.com",
  "http://www.lottolotto.com",
  "http://www.lotteryfun.net",
  "http://www.misourilotto.com",
  "http://www.molottery.net"
]

lotto_titles = [
  "WIN NOW",
  "Win big!",
  "Claim your jackpot"
]

suspicious_sites_charity = [
  "https://www.donateacar2charity.com/kansas-city-car-donation-information.php",
  "http://www.donate.me",
  "http://www.donatenow.com",
  "http://www.donatecash.com"
]

referral_sites = ["targat.com", "gardening.com", "amzon.com", "fabebok.com", "yahuu.com"]

suspicious_sites_redirect_from_email.each do |site|
  api_key = ENV['APIVOID_KEY']
  request = "https://endpoint.apivoid.com/urlrep/v1/pay-as-you-go/?key=#{api_key}&url=#{site}"
  risk_results_serialized = URI.parse(request).open.read
  results = JSON.parse(risk_results_serialized)

  notification = Notification.create!(
    user_id: zach.id,
    accessed_at: Faker::Date.between(from: '2022-08-27', to: '2022-08-27'),
    description: "Redirected from suspicious email.",
    read: false
  )

 Site.create!(
    status: :pending,
    user_id: zach.id,
    notification: notification,
    reason: "Redirected from suspicious email.",
    url: site,
    referral_site: ["email"],
    detections: results["data"]["report"]["domain_blacklist"]["detections"],
    risk_score: results["data"]["report"]["risk_score"]["result"],
    is_domain_recent: results["data"]["report"]["security_checks"]["is_domain_recent"],
    created_at: Faker::Time.between_dates(from: Date.today - 6, to: Date.today - 5, period: :morning, format: :short),
    webpage_title: "CREDIT CARD INFO NEEDED"
  )

  puts "Email notification notification.id and email site site.id made."
end

suspicious_sites_lotto.each do |site|
  api_key = ENV['APIVOID_KEY']
  request = "https://endpoint.apivoid.com/urlrep/v1/pay-as-you-go/?key=#{api_key}&url=#{site}"
  risk_results_serialized = URI.parse(request).open.read
  results = JSON.parse(risk_results_serialized)

  notification = Notification.create!(
    user_id: zach.id,
    accessed_at: Faker::Date.between(from: '2022-08-31', to: '2022-09-01'),
    description: "Suspicious lottery related site.",
    read: false
  )

 Site.create!(
    status: :pending,
    user_id: zach.id,
    notification: notification,
    reason: "Suspicious lottery related site.",
    url: site,
    referral_site: referral_sites.sample,
    detections: results["data"]["report"]["domain_blacklist"]["detections"],
    risk_score: results["data"]["report"]["risk_score"]["result"],
    is_domain_recent: results["data"]["report"]["security_checks"]["is_domain_recent"],
    created_at: Faker::Time.between_dates(from: Date.today - 2, to: Date.today - 1, period: :morning, format: :short),
    webpage_title: lotto_titles.sample
  )

  puts "Lotto notification notification.id and lotto site site.id made."
end

suspicious_sites_charity.each do |site|
  api_key = ENV['APIVOID_KEY']
  request = "https://endpoint.apivoid.com/urlrep/v1/pay-as-you-go/?key=#{api_key}&url=#{site}"
  risk_results_serialized = URI.parse(request).open.read
  results = JSON.parse(risk_results_serialized)

  notification = Notification.create!(
    user_id: zach.id,
    accessed_at: Faker::Date.between(from: '2022-08-27', to: '2022-08-30'),
    description: "#{results['data']['report']['domain_blacklist']['detections']} other site(s) flagged this as a risky URL",
    read: false
  )

 Site.create!(
    status: :pending,
    user_id: zach.id,
    notification: notification,
    reason: "Suspicious charity related site.",
    url: site,
    referral_site: referral_sites.sample,
    detections: "Suspicious charity related site.",
    risk_score: results["data"]["report"]["risk_score"]["result"],
    is_domain_recent: results["data"]["report"]["security_checks"]["is_domain_recent"],
    created_at: Faker::Time.between_dates(from: Date.today - 6, to: Date.today - 3, period: :morning, format: :short),
    webpage_title: "Donate in KC now!"
  )

  puts "Charity notification notification.id and charity site site.id made."
end
