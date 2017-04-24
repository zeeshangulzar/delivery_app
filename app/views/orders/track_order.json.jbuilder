json.order_id @order.id
json.status @order.status
json.date @order.created_at.strftime("%d %b %Y")
json.tracking_id @order.tracking_id
json.amount @order.amount
json.from {
    json.name @order.booking.user_name
    json.address @order.booking.try(:location).try(:address)
    json.lat @order.booking.try(:location).try(:lat)
    json.lng @order.booking.try(:location).try(:lon)
  }
json.to {
	json.name @order.recipient_name
    json.address @order.location.try(:address)
    json.lat @order.location.try(:lat)
    json.lng @order.location.try(:lon)
  }
