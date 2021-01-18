class Person < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :recommendations
  has_and_belongs_to_many :episodes, order: 'release_date DESC'

  scope :ordered, -> { joins(:episodes)
                         .order(Episode.arel_table[:release_date].desc)
                         .order(Person.arel_table[:last_name]).uniq }
  scope :current_hosts, -> { where(is_current_host: true).where(is_former_host: false) }
  scope :former_hosts, -> { where(is_current_host: false).where(is_former_host: true) }
  scope :guest_hosts, -> { where(is_current_host: false).where(is_former_host: false) }


  def full_name
    "#{first_name} #{last_name}"
  end
end