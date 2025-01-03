require 'spec_helper'
require_relative '../../../lib/github_client/client'
require_relative '../../../lib/github/repositories'

RSpec.describe Github::Repositories do
  let(:client) { described_class.new }

  describe '#fetch_repository' do
    let(:owner) { 'octocat' }
    let(:repo_name) { 'hello-world' }
    let(:api_response) { { id: 123, name: repo_name, owner: owner }.to_json }

    before do
      allow(client).to receive(:get).and_return(JSON.parse(api_response))
    end

    it 'calls the GET request with the correct endpoint' do
      client.fetch_repository(owner, repo_name)
      expect(client).to have_received(:get).with("/repos/#{owner}/#{repo_name}")
    end

    it 'returns the parsed response' do
      response = client.fetch_repository(owner, repo_name)
      expect(response).to eq(JSON.parse(api_response))
    end
  end

  describe '#fetch_multiple_repositories' do
    let(:requests) do
      [
        { url: '/repos/octocat/repo1' },
        { url: '/repos/octocat/repo2' }
      ]
    end
    let(:responses) do
      [
        { id: 1, name: 'repo1', owner: 'octocat' },
        { id: 2, name: 'repo2', owner: 'octocat' }
      ]
    end

    before do
      allow(client).to receive(:concurrent_requests).and_return(responses)
    end

    it 'calls concurrent_requests with the correct arguments' do
      client.fetch_multiple_repositories(requests)
      expect(client).to have_received(:concurrent_requests).with(requests)
    end

    it 'returns the expected response' do
      response = client.fetch_multiple_repositories(requests)
      expect(response).to eq(responses)
    end
  end
end
