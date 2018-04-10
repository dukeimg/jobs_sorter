require 'spec_helper'

describe 'JobsSorter', :module do
  subject { JobsSorter.run(input) }

  context 'empty string' do
    let(:input) { '' }

    it 'returns an empty array' do
      expect(subject).to eq([])
    end
  end
end