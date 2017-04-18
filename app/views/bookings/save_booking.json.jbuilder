json.message 'successful'
json.booking_id @booking.id

json.sender_details {
  json.name @booking.user_name
  json.cell @booking.user_cell
  json.email @booking.user_email
}

json.from {
  json.address @booking.location.address
  json.lat @booking.location.lat
  json.lng @booking.location.lon
}

json.orders{
  json.array! @booking.orders do |order|
    json.id order.id

    json.recipient_details {
      json.name order.recipient_name
      json.cell order.recipient_cell
      json.email order.recipient_email
    }

    json.to {
      json.address order.location.address
      json.lat order.location.lat
      json.lng order.location.lon
    }

    json.tracking_id order.tracking_id
    json.amount order.amount
    json.delivery_charges order.charges
    json.date order.created_at

  end
}
