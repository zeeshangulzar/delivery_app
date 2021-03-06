class SettingsController < ApplicationController

  before_action :token_authentication
  before_filter :set_format

  def status_code
    render 'status_code.json.jbuilder'
  end

  def configuration
    @configs = Config.where(api: true)
  end

end
