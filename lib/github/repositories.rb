module Github
  class Repositories < GithubClient::Client
    def fetch_repository(owner, repo_name)
      get("/repos/#{owner}/#{repo_name}")
    end

    def fetch_repository_topics(owner, repo_name)
      get("/repos/#{owner}/#{repo_name}/topics")
    end

    def fetch_multiple_repositories
      concurrent_requests(requests)
    end
  end
end
