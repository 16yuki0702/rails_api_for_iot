class ReadingsController < ApplicationController
  before_action :authenticate
  before_action :set_buffer

  def show
    reading = @buffer.reading(params[:number])
    return render json: { reading: reading, status: :success } if reading.present?

    begin
      render json: { reading: Reading.find_by(thermostats_id: @thermostat.id, number: params[:number]), status: :success }
    rescue StandardError
      not_found
    end
  end

  def create
    reading = build_reading(reading_params)
    @buffer.set_reading(reading)
    @buffer.keep_stat(reading)
    EventWorker.perform_async(@thermostat.id, reading.number)
    render json: { number: reading.number, status: :success }
  end

  private

  def reading_params
    params.require(:reading).permit(:temperature, :humidity, :battery_charge)
  end

  def build_reading(permitted)
    Reading.new(thermostats_id: @thermostat.id,
                number: @buffer.number,
                temperature: permitted[:temperature],
                humidity: permitted[:humidity],
                battery_charge: permitted[:battery_charge])
  end

  def not_found
    render json: { error: 'Record not found', status: :error }
  end
end
