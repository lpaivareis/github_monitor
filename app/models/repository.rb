class Repository < ApplicationRecord
  belongs_to :owner

  has_many :repository_contributors, dependent: :destroy
  has_many :contributors, through: :repository_contributors

  validates :name, :html_url, presence: true, uniqueness: true
end
