class Guest < ApplicationRecord
  has_many :reservations

  validates_presence_of :first_name, :last_name, :email
  serialize :phone_numbers, Array
end
