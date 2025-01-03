class Contributor < ApplicationRecord
  has_many :repository_contributors, dependent: :destroy
  has_many :repositories, through: :repository_contributors

  validates :name, :username, :html_url, presence: true
end
