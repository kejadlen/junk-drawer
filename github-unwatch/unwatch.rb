#!/usr/bin/env ruby

require "json"

(1..).each do |page|
  puts "page #{page}"
  watching = JSON.load(<<~`CMD`)
    curl \
      -u kejadlen:#{ENV.fetch("PAT")} \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/user/subscriptions?per_page=100\\&page=#{page}
    CMD
  exit if watching.empty?

  repos = watching
    .map {|x| x.fetch("full_name") }
    .grep(/pivotal-legacy/)

  repos.each do |repo|
    puts "unwatching #{repo}"
    cmd = <<~`CMD`
      curl \
        -u kejadlen:#{ENV.fetch("PAT")} \
        -X DELETE \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/repos/#{repo}/subscription
    CMD
  end
end
