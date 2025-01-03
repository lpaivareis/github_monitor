class Owner < ApplicationRecord
  has_many :repositories

  validates :login, :html_url, presence: true, uniqueness: true
end
