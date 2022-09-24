# frozen_string_literal: true

RSpec.describe AstroConcepts::Heading do
  subject { parent }

  let(:parent) { described_class.new(1, 0, 'Heading 1') }
  let(:child) { described_class.new(2, 1, 'Child heading') }

  describe '#initialize' do
    it 'has a depth' do
      expect(subject.depth).to eq(1)
    end

    it 'has a sequence' do
      expect(subject.sequence).to eq(0)
    end

    it 'has text' do
      expect(subject.text).to eq('Heading 1')
    end

    it 'has no parent' do
      expect(subject.parent).to be_nil
    end

    it 'has no headings' do
      expect(subject.headings).to be_nil
    end
  end

  describe '#add_heading' do
    before {
      parent.add_heading(child)
    }

    describe '.parent' do
      subject { child.parent }

      it 'has a parent' do
        expect(subject).to eq(parent)
      end
    end

    describe '.headings' do
      subject { parent.headings }

      it 'has headings' do
        expect(subject).to eq([child])
      end
    end
  end
end
