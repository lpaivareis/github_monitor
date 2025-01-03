module Api
  class RequestService < ApplicationService
    def initialize(requests, options = {})
      @requests = requests
      @options = options
      @api = Github::Repositories.new
    end

    def call
      call_request
    end

    private

    attr_accessor :requests, :options, :api

    def build_repository_requests
      formatted_requests = []

      requests.each do |request|
        formatted_requests << build_request(request)
      end

      formatted_requests
    end

    def build_request(request)
      { path: "/repos/#{request[:owner]}/#{request[:repo_name]}", options: options }
    end

    def call_request
      api.fetch_multiple_repositories(build_repository_requests)
    end
  end
end
