class ThermostatsController < ApplicationController
  before_action :set_thermostat, only: [:show, :update, :destroy]

  def index
    @thermostats = Thermostat.all

    render json: @thermostats
  end

  def show
    render json: @thermostat
  end

  def create
    @thermostat = Thermostat.new(thermostat_params)

    if @thermostat.save
      binding.pry
      render json: { token: @thermostat.household_token, status: :success }
    else
      render json: @thermostat.errors, status: :unprocessable_entity
    end
  end

  def update
    if @thermostat.update(thermostat_params)
      render json: @thermostat
    else
      render json: @thermostat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @thermostat.destroy
  end

  private
    def set_thermostat
      @thermostat = Thermostat.find(params[:id])
    end

    def thermostat_params
      permitted = params.require(:thermostat).permit(:household_token, :location)
      permitted[:location] = "POINT(#{permitted[:location]})"
      permitted
    end
end

