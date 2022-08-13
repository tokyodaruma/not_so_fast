json.array! @sites do |site|
  json.extract! site, :id, :url, :reason, :referral_site
end
