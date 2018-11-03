class StatsController < ApplicationController
  before_action :authenticate
  before_action :set_buffer

  def index
    render json: { stat: StatCalculator.new(thermostat: @thermostat).stat, status: :success }
  end
end
