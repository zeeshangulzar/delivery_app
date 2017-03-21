class SettingsController < ApplicationController

  before_action :token_authentication

  def status_code
    render 'status_code.json.jbuilder'
  end

end
