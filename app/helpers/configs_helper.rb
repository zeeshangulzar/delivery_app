module ConfigsHelper

  def check_api(config)
    config.api? ? 'Yes' : 'No'
  end

end
