require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "httpx", require: false
end

require "logger"
require "net/http"
require "json"

require "httpx"

LOGGER = Logger.new($stdout)
GOTOSOCIAL_TOKEN = ENV.fetch("GOTOSOCIAL_TOKEN")
PLEROMA_COOKIE = ENV.fetch("PLEROMA_COOKIE")
PLEROMA_PASSWORD = ENV.fetch("PLEROMA_PASSWORD")

API = Data.define(:subdomain, :http) do
  def verify_credentials
    resp = get("https://#{subdomain}.kejadlen.dev/api/v1/accounts/verify_credentials")
    LOGGER.debug(resp)
    JSON.parse(resp)
  end

  def following(id)
    return enum_for(__method__, id) unless block_given?

    uri = "https://#{subdomain}.kejadlen.dev/api/v1/accounts/#{id}/following?limit=100"

    loop do
      LOGGER.debug(uri)
      resp = get(uri)
      LOGGER.debug(resp)

      link = resp.headers["Link"]
      return if link.nil?

      uri = link.scan(/<((?~>))>; rel="(next|prev|)"/).to_h(&:reverse).fetch("next")
      followings = JSON.parse(resp)
      return if followings.empty?

      followings.each do |following|
        yield following
      end
    end
  end

  def unfollow(user)
    resp = post("https://#{subdomain}.kejadlen.dev/api/v1/accounts/#{user.fetch("id")}/unfollow")
    LOGGER.debug(resp)
  end

  def search(username)
    resp = get("https://#{subdomain}.kejadlen.dev/api/v1/search?q=@#{username}&resolve=true&type=accounts")
    LOGGER.debug(resp)
    json = JSON.parse(resp)
    accounts = json.fetch("accounts")
    if accounts.empty?
      LOGGER.warn("#{username} not found")
      return
    end
    accounts.fetch(0)
  end

  def follow(user)
    resp = post("https://#{subdomain}.kejadlen.dev/api/v1/accounts/#{user.fetch("id")}/follow")
    LOGGER.debug(resp)
  end

  def get(*) = http.get(*)
  def post(*) = http.post(*)
end

GTS = API.new(
  subdomain: "hey",
  http: HTTPX.plugin(:auth).bearer_auth(GOTOSOCIAL_TOKEN),
)
AKK = API.new(
  subdomain: "social",
  http: HTTPX.plugin(:cookies).with_cookies("__Host-pleroma_key" => PLEROMA_COOKIE),
)

if __FILE__ == $0
  gts_id = GTS.verify_credentials.fetch("id")
  akk_id = AKK.verify_credentials.fetch("id")

  gts_following = GTS.following(gts_id).to_a
  akk_following = AKK.following(akk_id).to_a

  # unfollow already followed
  already_followed, to_follow = akk_following.partition {|akk|
    gts_following.any? {|gts| gts.fetch("acct") == akk.fetch("acct") }
  }
  already_followed.each do |user|
    AKK.unfollow(user)
  end

  # follow not already followed
  ignore = File.read("friends.csv").scan(/# (.*)/).map { _1[0] }
  to_follow = to_follow.map { _1.fetch("acct") }.reject { ignore.include?(_1) }
  LOGGER.debug("To follow: #{to_follow}")

  to_follow.sample(5).each do |username|
    LOGGER.info("Following: #{username}")
    user = GTS.search(username)
    if user
      GTS.unfollow(user)
      GTS.follow(user)
    else
      LOGGER.warn("Couldn't find: #{username}")
    end
  end

  # move account
  # resp = AKK.http.post(
  #   "https://#{AKK.subdomain}.kejadlen.dev/api/pleroma/move_account",
  #   json: {
  #     password: PLEROMA_PASSWORD,
  #     target_account: "alpha@hey.kejadlen.dev",
  #   },
  # )
end
