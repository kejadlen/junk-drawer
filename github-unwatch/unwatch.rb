#!/usr/bin/env ruby

require "json"

def unwatch(repo)
  puts "unwatching #{repo}"
  cmd = <<~CMD.gsub("\n", " ")
    curl
      -u kejadlen:#{ENV.fetch("PAT")}
      -X DELETE
      -H "Accept: application/vnd.github.v3+json"
      https://api.github.com/repos/#{repo}/subscription
  CMD
  `#{cmd}`
end

watching = JSON.load(File.read("watching.json"))

repos = watching
  .map {|x| x.fetch("full_name") }
  .grep(/pivotal-legacy/)

repos.each do |repo|
  unwatch(repo)
end
