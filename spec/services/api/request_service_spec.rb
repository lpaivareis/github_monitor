require 'rails_helper'

RSpec.describe Api::RequestService do
  let(:requests) do
    [
      { owner: 'rails', repo_name: 'rails' },
      { owner: 'ruby', repo_name: 'ruby' }
    ]
  end

  let(:options) { {} }
  let(:service) { described_class.new(requests, options) }
  let(:api_client) { instance_double(Github::Repositories) }

  before do
    allow(Github::Repositories).to receive(:new).and_return(api_client)
  end

  describe '#call' do
    let(:response_data) { [ { id: 1 }, { id: 2 } ] }

    before do
      allow(api_client).to receive(:fetch_multiple_repositories).and_return(response_data)
    end

    it 'fetches data from multiple repositories' do
      expect(service.call).to eq(response_data)
    end

    it 'builds repository requests with correct paths' do
      expected_requests = [
        { path: '/repos/rails/rails', options: {} },
        { path: '/repos/ruby/ruby', options: {} }
      ]

      service.call
      expect(api_client).to have_received(:fetch_multiple_repositories).with(expected_requests)
    end
  end
end
