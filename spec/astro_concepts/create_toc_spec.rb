# frozen_string_literal: true

RSpec.describe AstroConcepts::CreateToc do
  let(:instance) { described_class.new(raw_headings.headings) }

  subject { subject }

  # fit { puts instance.to_h }
  # it { instance.debug }

  # Use this to construct a list of sample headings
  let(:heading_builder) { AstroHeadingListBuilder.new }

  context 'scenarios' do
    subject { instance.hierarchies }

    before { instance.process }

    context 'single root heading' do
      context 'with simple nesting levels' do
        # H1
        #   H2
        #     H3
        let(:raw_headings) do
          heading_builder
            .h1('Heading 1')
            .h2('Heading 2')
            .h3('Heading 3')
        end

        it { is_expected.to be_a(Array).and have_attributes(length: 1) }

        describe '#to_h' do
          subject { instance.to_h }

          it do
            is_expected.to eq([
                                { depth: 1, sequence: 0, text: 'Heading 1',
                                  headings: [
                                    { depth: 2, sequence: 1, text: 'Heading 2',
                                      headings: [
                                        { depth: 3, sequence: 2, text: 'Heading 3' }
                                      ] }
                                  ] }
                              ])
          end
        end
      end

      context 'with skipped nesting levels' do
        # H1
        #     H3
        #           H6
        let(:raw_headings) do
          heading_builder
            .h1('Heading 1')
            .h2('Heading 2')
            .h6('Heading 6')
        end

        it { is_expected.to be_a(Array).and have_attributes(length: 1) }

        describe '#to_h' do
          subject { instance.to_h }

          it do
            is_expected.to eq([
                                { depth: 1, sequence: 0, text: 'Heading 1',
                                  headings: [
                                    { depth: 2, sequence: 1, text: 'Heading 2',
                                      headings: [
                                        { depth: 6, sequence: 2, text: 'Heading 6' }
                                      ] }
                                  ] }
                              ])
          end
        end
      end

      context 'with siblings' do
        # H1
        #   H2
        #     H3
        #   H2
        #       H4
        #       H4
        let(:raw_headings) do
          heading_builder
            .h1('Heading 1')
            .h2('Heading 2')
            .h2('Heading 2 - sibling')
            .h4('Heading 4')
            .h4('Heading 4 - sibling')
        end

        it { is_expected.to be_a(Array).and have_attributes(length: 1) }

        describe '#to_h' do
          subject { instance.to_h }

          it do
            is_expected.to eq([
                                { depth: 1, sequence: 0, text: 'Heading 1',
                                  headings: [
                                    { depth: 2, sequence: 1, text: 'Heading 2' },
                                    { depth: 2, sequence: 2, text: 'Heading 2 - sibling',
                                      headings: [
                                        { depth: 4, sequence: 3, text: 'Heading 4' },
                                        { depth: 4, sequence: 4, text: 'Heading 4 - sibling' }
                                      ] }
                                  ] }
                              ])
          end
        end
      end

      context 'with upstream heading' do
        # H1
        #   H2
        #     H3
        #   H2
        #       H4
        #   H2
        let(:raw_headings) do
          heading_builder
            .h1('Heading 1')
            .h2('Heading 2')
            .h3('Heading 3')
            .h2('Heading 2 - upstream')
            .h4('Heading 4')
            .h2('Heading 2 - different upstream')
        end

        it { is_expected.to be_a(Array).and have_attributes(length: 1) }

        describe '#to_h' do
          subject { instance.to_h }

          it do
            is_expected.to eq([

                                { depth: 1, sequence: 0, text: 'Heading 1',
                                  headings: [
                                    { depth: 2, sequence: 1, text: 'Heading 2',
                                      headings: [
                                        { depth: 3, sequence: 2, text: 'Heading 3' }
                                      ] },
                                    { depth: 2, sequence: 3, text: 'Heading 2 - upstream',
                                      headings: [
                                        { depth: 4, sequence: 4, text: 'Heading 4' }
                                      ] },
                                    { depth: 2, sequence: 5, text: 'Heading 2 - different upstream' }
                                  ] }

                              ])
          end
        end
      end
    end

    context 'multiple root headings' do
      context 'with  common multiple root headings' do
        # H2
        #     H4
        # H2
        let(:raw_headings) do
          heading_builder
            .h2('Heading 2')
            .h4('Heading 4')
            .h2('Heading 2')
        end

        it { is_expected.to be_a(Array).and have_attributes(length: 2) }

        describe '#to_h' do
          subject { instance.to_h }

          it do
            is_expected.to eq([
                                { depth: 2, sequence: 0, text: 'Heading 2',
                                  headings: [
                                    { depth: 4, sequence: 1, text: 'Heading 4' }
                                  ] },
                                { depth: 2, sequence: 2, text: 'Heading 2' }
                              ])
          end
        end
      end

      context 'with reversed hierarchy' do
        #         H5
        #       H4
        #         H5 - connected to H4
        #     H3
        #   H2
        # H1
        let(:raw_headings) do
          heading_builder
            .h5('Heading 5')
            .h4('Heading 4')
            .h5('Heading 5 - connected to H4')
            .h3('Heading 3')
            .h2('Heading 2')
            .h1('Heading 1')
        end

        it { is_expected.to be_a(Array).and have_attributes(length: 5) }

        describe '#to_h' do
          subject { instance.to_h }

          it do
            is_expected.to eq([
                                { depth: 5, sequence: 0, text: 'Heading 5' },
                                { depth: 4, sequence: 1, text: 'Heading 4',
                                  headings: [
                                    { depth: 5, sequence: 2, text: 'Heading 5 - connected to H4' }
                                  ] },
                                { depth: 3, sequence: 3, text: 'Heading 3' },
                                { depth: 2, sequence: 4, text: 'Heading 2' },
                                { depth: 1, sequence: 5, text: 'Heading 1' }
                              ])
          end
        end
      end
    end
  end
end
