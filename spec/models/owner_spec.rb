require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe 'associations' do
    it { should have_many(:repositories) }
  end

  describe 'validations' do
    subject { described_class.new(login: 'Rails', html_url: 'www.google.com') }

    it { should validate_presence_of(:login) }
    it { should validate_presence_of(:html_url) }
    it { should validate_uniqueness_of(:login) }
    it { should validate_uniqueness_of(:html_url) }
  end
end
