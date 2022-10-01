require 'json'
require 'open-uri'

class CheckRisk < ApplicationService
  attr_reader :site

  def initialize(site)
    @site = site
    @url = site["url"]
  end

  def call
    api_key = ENV['APIVOID_KEY']
    request = "https://endpoint.apivoid.com/urlrep/v1/pay-as-you-go/?key=#{api_key}&url=#{@url}"
    risk_results_serialized = URI.parse(request).open.read
    # getResultsJob.perform_later(request)
    # move line 15 to job file
    get_risk_score(JSON.parse(risk_results_serialized))
  end

  private

  def get_risk_score(results)
    if results["error"] == "Url is not valid"
      {
        detections: '',
        risk_score: 0,
        accessed_at: '',
        is_domain_recent: '',
        webpage_title: ''
      }
    else
      {
        detections: results["data"]["report"]["domain_blacklist"]["detections"],
        risk_score: results["data"]["report"]["risk_score"]["result"],
        accessed_at: results["data"]["report"]["response_headers"]["date"],
        is_domain_recent: results["data"]["report"]["security_checks"]["is_domain_recent"],
        webpage_title: results["data"]["report"]["web_page"]["title"]
      }
    end
  end
end
