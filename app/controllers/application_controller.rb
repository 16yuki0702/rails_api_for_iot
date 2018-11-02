class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  protected

    def request_http_token_authentication(realm = 'Application', message = nil)
      self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, "")}")
      render json: { error: 'Access denied', status: :unauthorized }
    end
end
