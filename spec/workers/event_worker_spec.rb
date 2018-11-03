require 'rails_helper'

RSpec.describe EventWorker do
  describe '#perform' do
    it 'should be enqueue' do
      expect do
        EventWorker.perform_async(1, 1)
      end.to change(EventWorker.jobs, :size).by(1)
    end
  end
end
