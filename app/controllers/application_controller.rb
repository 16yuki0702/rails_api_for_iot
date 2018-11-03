class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protected

  def request_http_token_authentication(realm = 'Application', _message = nil)
    headers['WWW-Authenticate'] = %(Token realm="#{realm.delete('"')}")
    render json: { error: 'Access denied', status: :unauthorized }
  end

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      @thermostat = Thermostat.find_by(household_token: token)
    end
  end

  def set_buffer
    @buffer = BufferManager.new(thermostat: @thermostat)
  end
end
