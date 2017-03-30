module ApplicationHelper

  def time_format(time, format=nil)
    return unless time
    if format
      time.strftime(format)
    else
      time.strftime('%d %b %Y %I:%M %P')
    end
  end

  def append_qar(amount)
    return 'QAR '+amount.to_s if amount.present?
  end

  def payby(order)
    return order.pay_by_sender ? order.booking.user_name : order.recipient_name
  end

end
