class Recommendation < ApplicationRecord
  validates_presence_of :name

  belongs_to :person
  belongs_to :episode
end