module Github
  class Repositories < GithubClient::Client
    def fetch_repository(owner, repo_name)
      get("/repos/#{owner}/#{repo_name}")
    end

    def fetch_multiple_repositories(requests)
      concurrent_requests(requests)
    end
  end
end
