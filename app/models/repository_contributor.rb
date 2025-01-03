class RepositoryContributor < ApplicationRecord
  belongs_to :repository
  belongs_to :contributor
end
