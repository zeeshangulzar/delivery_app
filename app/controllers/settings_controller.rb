class SettingsController < ApplicationController

  def status_code
    render 'status_code.json.jbuilder'
  end

end
