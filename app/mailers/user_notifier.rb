class UserNotifier < ApplicationMailer

  default from: "noreply@ana.com"

  def booking_email
    mail( to: ['zeeshan@novatoresols.com'], subject: 'ANA Booking Details' )
  end


end
