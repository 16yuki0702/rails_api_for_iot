class ReadingsController < ApplicationController
  before_action :set_reading, only: :show

  def show
  end

  def create
    permitted = reading_params

    @thermostat = Thermostat.find_by(household_token: permitted[:household_token])
    if @thermostat.nil?
      return render json: { status: :unauthorized }
    end

    if DataBuffer.get(sequence_key).nil?
      @thermostat.sequence.with_lock do
        DataBuffer.set(sequence_key, @thermostat.sequence.number)
      end
    end

    @reading = Reading.new(thermostats_id: @thermostat.id,
                           number: DataBuffer.incr(sequence_key),
                           temperature: permitted[:temperature],
                           humidity: permitted[:humidity],
                           battery_charge: permitted[:battery_charge])

    if @reading.save
      render json: @reading, status: :success
    else
      render json: @reading.errors, status: :error
    end
  end

  private
    def set_reading
      @reading = Reading.find(params[:id])
    end

    def reading_params
      params.permit(:household_token, :temperature, :humidity, :battery_charge)
    end

    def sequence_key
      "sequence_#{@thermostat.id}"
    end
end
