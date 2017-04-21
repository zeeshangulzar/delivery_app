json.total_pages @orders.total_pages
json.bookings @orders do |order|

  json.booking_id order.booking.try(:id)

  json.sender_details {
    json.name order.booking.try(:user_name)
    json.cell order.booking.try(:user_cell)
    json.email order.booking.try(:user_email)
  }

  json.from {
    json.address order.booking.try(:location).try(:address)
    json.lat order.booking.try(:location).try(:lat)
    json.lng order.booking.try(:location).try(:lon)
  }

  json.orders{
    json.array! array_method(order) do |order|
      json.id order.id

      json.recipient_details {
        json.name order.recipient_name
        json.cell order.recipient_cell
        json.email order.recipient_email
      }

      json.to {
        json.address order.location.try(:address)
        json.lat order.location.try(:lat)
        json.lng order.location.try(:lon)
      }

      json.tracking_id order.tracking_id
      json.amount order.amount.to_i
      json.delivery_charges order.charges
      json.date order.created_at

    end
  }
end
