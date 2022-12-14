# frozen_string_literal: true

RSpec.describe AstroConcepts::AstroToc do
  let(:instance) { described_class.new }

  subject { subject }

  let(:heading_builder) { AstroHeadingListBuilder.new }

  context 'scenarios' do
    subject { instance.toc.headings }

    before { instance.process(raw_headings.to_a) }

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
          subject { instance.root_headings.map(&:to_h) }

          it do
            is_expected.to eq([
                                {
                                  depth: 1, sequence: 0, text: 'Heading 1', slug: 'heading-1',
                                  headings: [
                                    {
                                      depth: 2, sequence: 1, text: 'Heading 2', slug: 'heading-2',
                                      headings: [
                                        {
                                          depth: 3, sequence: 2, text: 'Heading 3', slug: 'heading-3'
                                        }
                                      ]
                                    }
                                  ]
                                }
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
          subject { instance.root_headings.map(&:to_h) }

          it do
            is_expected.to eq([
                                {
                                  depth: 1, sequence: 0, text: 'Heading 1', slug: 'heading-1',
                                  headings: [
                                    {
                                      depth: 2, sequence: 1, text: 'Heading 2', slug: 'heading-2',
                                      headings: [
                                        {
                                          depth: 6, sequence: 2, text: 'Heading 6', slug: 'heading-6'
                                        }
                                      ]
                                    }
                                  ]
                                }
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
          subject { instance.root_headings.map(&:to_h) }

          it do
            is_expected.to eq([
                                { depth: 1, sequence: 0, text: 'Heading 1', slug: 'heading-1',
                                  headings: [
                                    { depth: 2, sequence: 1, text: 'Heading 2', slug: 'heading-2' },
                                    { depth: 2, sequence: 2, text: 'Heading 2 - sibling', slug: 'heading-2---sibling',
                                      headings: [
                                        { depth: 4, sequence: 3, text: 'Heading 4', slug: 'heading-4' },
                                        { depth: 4, sequence: 4, text: 'Heading 4 - sibling', slug: 'heading-4---sibling' }
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
          subject { instance.root_headings.map(&:to_h) }

          it do
            is_expected.to eq([
                                { depth: 1, sequence: 0, text: 'Heading 1', slug: 'heading-1',
                                  headings: [
                                    { depth: 2, sequence: 1, text: 'Heading 2', slug: 'heading-2',
                                      headings: [
                                        { depth: 3, sequence: 2, text: 'Heading 3', slug: 'heading-3' }
                                      ] },
                                    { depth: 2, sequence: 3, text: 'Heading 2 - upstream', slug: 'heading-2---upstream',
                                      headings: [
                                        { depth: 4, sequence: 4, text: 'Heading 4', slug: 'heading-4' }
                                      ] },
                                    {
                                      depth: 2, sequence: 5, text: 'Heading 2 - different upstream', slug: 'heading-2---different-upstream'
                                    }
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
          subject { instance.root_headings.map(&:to_h) }

          # fit { instance.pretty }
          it do
            is_expected.to eq([
                                { depth: 2, sequence: 0, text: 'Heading 2', slug: 'heading-2',
                                  headings: [
                                    { depth: 4, sequence: 1, text: 'Heading 4', slug: 'heading-4' }
                                  ] },
                                { depth: 2, sequence: 2, text: 'Heading 2', slug: 'heading-2' }
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
            .h6('Heading 6 - connected to H1')
        end

        it { is_expected.to be_a(Array).and have_attributes(length: 5) }

        describe '#to_h' do
          subject { instance.root_headings.map(&:to_h) }

          # fit { instance.pretty }
          it do
            is_expected.to eq([
                                { depth: 5, sequence: 0, text: 'Heading 5', slug: 'heading-5' },
                                { depth: 4, sequence: 1, text: 'Heading 4', slug: 'heading-4',
                                  headings: [
                                    {
                                      depth: 5, sequence: 2, text: 'Heading 5 - connected to H4', slug: 'heading-5---connected-to-h4'
                                    }
                                  ] },
                                { depth: 3, sequence: 3, text: 'Heading 3', slug: 'heading-3' },
                                { depth: 2, sequence: 4, text: 'Heading 2', slug: 'heading-2' },
                                { depth: 1, sequence: 5, text: 'Heading 1', slug: 'heading-1',
                                  headings: [
                                    { depth: 6, sequence: 6, text: 'Heading 6 - connected to H1', slug: 'heading-6---connected-to-h1' }
                                  ] }
                              ])
          end
        end
      end
    end
  end
end
