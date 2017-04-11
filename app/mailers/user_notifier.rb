class UserNotifier < ApplicationMailer

  default from: "noreply@ana.com"

  def booking_email(booking)
    @booking = booking
    mail( to: [booking.user_email], subject: 'ANA Booking Details' )
  end

  def order_email(order)
    @order = order
    mail( to: [order.recipient_email], subject: 'ANA Booking Details' )
  end

end
