# frozen_string_literal: true

RSpec.describe AstroConcepts do
  it 'has a version number' do
    expect(AstroConcepts::VERSION).not_to be nil
  end

  it 'has a standard error' do
    expect { raise AstroConcepts::Error, 'some message' }
      .to raise_error('some message')
  end
end
