require 'octokit'

module GithubClient
  class Client
    attr_accessor :api_key, :client

    def initialize
      @api_key = ENV['GITHUB_ACCESS_TOKEN']
      @client = Octokit::Client.new(access_token: api_key)
      @client.auto_paginate = true
    end

    def get(path, options = {})
      check_rate_limit
      client.get(path, options)
    rescue Octokit::Error => error
      raise "Error fetching #{path}: #{error.message}"
    end

    def concurrent_requests(requests)
      check_rate_limit
      ractors_requests(requests).map do |request|
        begin
          { result: client.get(request[:path], request[:options]), error: nil }
        rescue Octokit::Error => error
          { result: nil, error: "Error fetching #{request[:path]}: #{error.message}" }
        end
      end
    end

    private

    def check_rate_limit
      rate_limit = client.rate_limit
      remaining = rate_limit.remaining
      reset_time = rate_limit.resets_at

      if remaining.zero?
        wait_time = reset_time - Time.now
        Rails.logger.info("Rate limit exceeded. Waiting for #{wait_time.ceil} seconds")
        sleep(wait_time.ceil)
      end
    end

    def ractors_requests(requests)
      ractors = requests.map do |request|
        Ractor.new(request) do |request|
          { path: request[:path], options: request[:options] }
        end
      end

      ractors.map(&:take)
    end
  end
end
