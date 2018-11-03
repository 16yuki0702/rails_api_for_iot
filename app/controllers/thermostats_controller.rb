class ThermostatsController < ApplicationController
  def create
    @thermostat = Thermostat.new(thermostat_params)
    if @thermostat.save_init_data
      render json: { token: @thermostat.household_token, status: :success }
    else
      render json: { error: @thermostat.errors, status: :unprocessable_entity }
    end
  end

  private

  def thermostat_params
    permitted = params.require(:thermostat).permit(:household_token, :location)
    permitted[:location] = "POINT(#{permitted[:location]})"
    permitted
  end
end
