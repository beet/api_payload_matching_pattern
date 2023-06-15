class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.integer :guest_id
      t.string :code
      t.date :start_date
      t.date :end_date
      t.integer :nights
      t.integer :guests
      t.integer :adults
      t.integer :children
      t.integer :infants
      t.string :booking_status
      t.string :currency
      t.float :total_price

      t.timestamps
    end
  end
end
