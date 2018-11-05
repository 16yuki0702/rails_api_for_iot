require 'rails_helper'

RSpec.describe 'Thermostats', type: :request do
  describe 'POST /readings' do
    let(:params) { { thermostat: { location: '1 1' } } }
    let(:invalid_params) { { thermostat: { location: '' } } }

    context 'when valid params' do
      it 'returns created token' do
        post '/thermostats', params: params

        res = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(res['token']).not_to eq(nil)
      end
    end

    context 'when invalid params' do
      it "doesn't return created token" do
        post '/thermostats', params: invalid_params

        res = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json')
        expect(res['token']).to eq(nil)
      end
    end
  end
end
