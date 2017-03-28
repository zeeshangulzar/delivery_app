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
    return 'QAR '+amount.to_s
  end

end
