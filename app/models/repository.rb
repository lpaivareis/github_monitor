class Repository < ApplicationRecord
  belongs_to :owner

  validates :name, :html_url, presence: true, uniqueness: true
end
