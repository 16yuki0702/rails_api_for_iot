require 'rails_helper'

RSpec.describe ThermostatsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/thermostats').to route_to('thermostats#create')
    end
  end
end
