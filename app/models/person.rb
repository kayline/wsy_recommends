class Person < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :recommendations

  def full_name
    "#{first_name} #{last_name}"
  end
end