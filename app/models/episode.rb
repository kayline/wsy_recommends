class Episode < ApplicationRecord
  validates_presence_of :title
  validates_uniqueness_of :number

  has_many :recommendations
  has_and_belongs_to_many :people
end