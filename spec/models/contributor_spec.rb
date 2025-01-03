require 'rails_helper'

RSpec.describe Contributor, type: :model do
  describe 'associations' do
    it { should have_many(:repository_contributors).dependent(:destroy) }
    it { should have_many(:repositories).through(:repository_contributors) }
  end

  describe 'validations' do
    subject { described_class.new(name: 'John Doe', username: 'johndoe', html_url: 'www.google.com') }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:html_url) }
  end
end
