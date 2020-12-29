class Episode < ApplicationRecord
  validates_presence_of :title

  has_many :recommendations
end