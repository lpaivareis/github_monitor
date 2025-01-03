require 'rails_helper'

RSpec.describe RepositoryContributor, type: :model do
  describe 'associations' do
    it { should belong_to(:repository) }
    it { should belong_to(:contributor) }
  end
end
