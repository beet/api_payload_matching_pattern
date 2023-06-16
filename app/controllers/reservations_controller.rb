class ReservationsController < ApplicationController
  def create
    reservation = Reservations::CreationService.new(request.raw_post).run

    render(
      json: {
        guest: reservation.guest,
        reservation: reservation,
        errors: reservation.errors.full_messages.to_sentence
      },
      status: reservation.errors.any? ? 400 : 200
    )
  end
end
