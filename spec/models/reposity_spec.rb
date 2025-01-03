require 'rails_helper'

RSpec.describe Repository, type: :model do
  describe 'associations' do
    it { should belong_to(:owner) }
  end

  describe 'validations' do
    let(:owner) { Owner.new(login: 'Rails', html_url: 'www.google.com') }
    subject { described_class.new(name: 'repo', html_url: 'www.google.com', owner: owner) }


    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:html_url) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:html_url) }
  end
end
