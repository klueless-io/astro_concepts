# frozen_string_literal: true

RSpec.describe AstroConcepts::Root do
  subject { described_class.new }

  describe '#initialize' do
    it 'has no roots' do
      expect(subject.roots).to be_empty
    end
  end
end
