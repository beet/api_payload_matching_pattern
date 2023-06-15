class Reservation < ApplicationRecord
  belongs_to :guest

  validates_associated :guest
  validates_presence_of :code, :start_date, :end_date, :nights
  validates_uniqueness_of :code, scope: :guest_id
end
