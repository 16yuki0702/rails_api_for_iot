class StatsController < ApplicationController
  before_action :authenticate
  before_action :set_buffer

  def index
    calculator = StatCalculator.new(thermostat: @thermostat)
    render json: { stat: calculator.stat, status: :success }
  end

  private

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        @thermostat = Thermostat.find_by(household_token: token)
      end
    end

    def set_buffer
      @buffer = BufferManager.new(thermostat: @thermostat)
    end
end
