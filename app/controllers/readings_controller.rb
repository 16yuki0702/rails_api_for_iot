class ReadingsController < ApplicationController
  before_action :authenticate

  def show
    begin
      cache = DataBuffer.get(reading_key(params[:number]))
      if cache.nil?
        @reading = Reading.find(number: params[:number])
      else
        @reading = JSON.parse(cache)
      end
    rescue
      return not_found
    end

    render json: { reading: @reading, status: :success }
  end

  def create
    permitted = create_reading_params

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

    DataBuffer.multi do
      key = reading_key(@reading.number)
      DataBuffer.set(key, @reading.to_json)
      DataBuffer.expire(key, 60 * 60 * 24)
    end

    @thermostat.sequence.increment!('number', 1)

    if @reading.save
      render json: { reading: @reading, status: :success }
    else
      render json: { error: @reading.errors, status: :error }
    end
  end

  private

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        @thermostat = Thermostat.find_by(household_token: token)
      end
    end

    def create_reading_params
      params.require(:reading).permit(:temperature, :humidity, :battery_charge)
    end

    def sequence_key
      "sequence_#{@thermostat.id}"
    end

    def reading_key(number)
      "reading_#{@thermostat.id}_#{number}"
    end

    def not_found
      render json: { error: 'Record not found', status: :error }
    end
end
