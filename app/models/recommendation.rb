class Recommendation < ApplicationRecord
  validates_presence_of :name

  belongs_to :person
  belongs_to :episode

  default_scope { includes(:episode).includes(:person).order("episodes.release_date desc").order("people.first_name") }
end