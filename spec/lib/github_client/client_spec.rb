require 'rails_helper'

RSpec.describe GithubClient::Client do
  let(:client) { described_class.new }
  let(:octokit_client) { instance_double(Octokit::Client) }
  let(:rate_limit) { double(remaining: 100, resets_at: Time.now + 3600) }

  before do
    allow(ENV).to receive(:[]).with('GITHUB_ACCESS_TOKEN').and_return('fake_token')
    allow(Octokit::Client).to receive(:new).and_return(octokit_client)
    allow(octokit_client).to receive(:auto_paginate=)
    allow(octokit_client).to receive(:rate_limit).and_return(rate_limit)
  end

  describe '#initialize' do
    it 'sets up the Octokit client with access token' do
      expect(Octokit::Client).to receive(:new).with(access_token: 'fake_token')
      client
    end

    it 'enables auto pagination' do
      expect(octokit_client).to receive(:auto_paginate=).with(true)
      client
    end
  end

  describe '#get' do
    it 'makes a successful GET request' do
      expect(octokit_client).to receive(:get).with('/test/path', {}).and_return('response')
      expect(client.get('/test/path')).to eq('response')
    end

    it 'raises error on failed request' do
      allow(octokit_client).to receive(:get).and_raise(Octokit::Error.new)
      expect { client.get('/test/path') }.to raise_error(/Error fetching/)
    end
  end

  describe '#concurrent_requests' do
    let(:requests) do
      [
        { path: '/path1', options: {} },
        { path: '/path2', options: { page: 2 } }
      ]
    end

    it 'processes multiple requests concurrently' do
      allow(octokit_client).to receive(:get)
        .with('/path1', {}).and_return('response1')
      allow(octokit_client).to receive(:get)
        .with('/path2', { page: 2 }).and_return('response2')

      results = client.concurrent_requests(requests)

      expect(results).to contain_exactly(
        { result: 'response1', error: nil },
        { result: 'response2', error: nil }
      )
    end

    it 'handles errors in concurrent requests' do
      allow(octokit_client).to receive(:get)
        .with('/path1', {}).and_raise(Octokit::Error.new)
      allow(octokit_client).to receive(:get)
        .with('/path2', { page: 2 }).and_return('response2')

      results = client.concurrent_requests(requests)

      expect(results.map { |r| r[:error].nil? }).to contain_exactly(false, true)
    end
  end

  describe '#check_rate_limit' do
    context 'when rate limit is exceeded' do
      let(:rate_limit) { double(remaining: 0, resets_at: Time.now + 2) }

      it 'waits for rate limit reset' do
        allow(Rails.logger).to receive(:info)
        expect(client).to receive(:sleep).with(kind_of(Integer))
        client.send(:check_rate_limit)
      end
    end
  end
end
