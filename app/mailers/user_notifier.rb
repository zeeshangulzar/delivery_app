class UserNotifier < ApplicationMailer

  default from: "noreply@ana.com"
  before_action :set_image

  def set_image
    attachments.inline["no_product.jpg"] = File.read("#{Rails.root}/app/assets/images/no_product.jpg")
  end

  def booking_email(booking)
    @booking = booking
    mail( to: [booking.user_email], subject: 'ANA Booking Details' )
  end

  def order_email(order)
    @order = order
    mail( to: [order.recipient_email], subject: 'ANA Booking Details' )
  end

end
