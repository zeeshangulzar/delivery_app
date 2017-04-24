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

  def array_method(item)
    [item]
  end

  def change_date_format(date)
    date.strftime("%Y-%m-%d")
  end

  def format_description(text)
    return if text.blank?
    value = text.gsub("\r", "").split("\n").reject { |t| t.empty? }
    value = value.first if value.count == 1
    value
  end

end
