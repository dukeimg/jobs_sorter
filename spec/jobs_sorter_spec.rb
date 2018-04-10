require 'spec_helper'

describe 'JobsSorter', :module do
  subject { JobsSorter.run(input) }

  context 'empty string' do
    let(:input) { '' }

    it 'returns an empty array' do
      expect(subject).to eq([])
    end
  end

  context 'simple structure #1' do
    let(:input) { { a: nil }.to_json }

    it 'returns an unmodified sequence' do
      expected_sequence = ['a']
      expect(subject).to eq(expected_sequence)
    end
  end

  context 'simple structure #2' do
    let(:input) { { a: nil, b: nil, c: nil }.to_json }

    it 'returns an unmodified sequence' do
      expected_sequence = %w[a b c]
      expect(subject).to eq(expected_sequence)
    end
  end

  context 'nested structure #1' do
    let(:input) { { a: nil, b: 'c', c: nil }.to_json }

    it 'returns a sorted sequence' do
      expected_sequence = %w[a c b]
      expect(subject).to eq(expected_sequence)
    end
  end

  context 'nested structure #2' do
    let(:input) { { a: nil, b: 'c', c: 'f', d: 'a', e: 'b', f: nil }.to_json }

    it 'returns a sorted sequence' do
      expected_sequence = %w[a f c b d e]
      expect(subject).to eq(expected_sequence)
    end
  end

  context 'nested structure #3' do
    let(:input) { { a: 'f', b: 'c', c: 'f', d: 'a', e: 'b', f: nil }.to_json }

    it 'returns a sorted sequence' do
      expected_sequence = %w[f a c b d e]
      expect(subject).to eq(expected_sequence)
    end
  end

  context 'self-dependence' do
    let(:input) { { a: nil, b: nil, c: 'c' }.to_json }

    it 'raises an exception' do
      err_msg = "Jobs can't depend on themselves"
      expect { subject }.to raise_error(ArgumentError, err_msg)
    end
  end

  context 'circular dependence' do
    let(:input) { { a: nil, b: 'c', c: 'f', d: 'a', e: nil, f: 'b' }.to_json }

    it 'raises an exception' do
      err_msg = "Jobs dependencies can't loop"
      expect { subject }.to raise_error(ArgumentError, err_msg)
    end
  end
end