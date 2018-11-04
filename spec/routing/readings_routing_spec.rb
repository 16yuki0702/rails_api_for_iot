require 'rails_helper'

RSpec.describe ReadingsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/readings/1').to route_to('readings#show', number: '1')
    end

    it 'routes to #create' do
      expect(post: '/readings').to route_to('readings#create')
    end
  end
end
