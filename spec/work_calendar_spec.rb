require 'spec_helper'

RSpec.describe WorkCalendar do
  describe '#configure' do
    subject { described_class.configure }

    context 'when block is provided' do
      it 'yields with self' do
        expect{
          |b| described_class.configure(&b)
        }.to yield_with_args described_class
      end

      context 'when block does not contain holiday list' do
        it 'sets holidays to empty list' do
          subject do |c|
            c.weekdays = []
          end
          expect(described_class.holidays).to eq([])
        end
      end

      context 'when block does not contain weekdays list' do
        it 'sets weekdays to empty' do
          subject do |c|
            c.holidays = []
          end
          expect(described_class.weekdays).to eq([])
        end
      end
    end

    context 'when block is not provided' do
      specify { expect { |b| subject(&b) }.not_to yield_control }

      it 'initializes the holidays to empty array' do
        subject
        expect(described_class.holidays).to eq([])
      end

      it 'initializes the weekdays to empty array' do
        subject
        expect(described_class.weekdays).to eq([])
      end
    end
  end

  describe '#active?' do
    subject { described_class.active?(date) }

    let(:date) { Date.new(2015, 1, 1) }
    let(:weekdays) { [:mon, :tue] }
    let(:holidays) { [Date.new(2015, 1, 1)] }

    before do
      allow(described_class).to receive(:weekdays).and_return(weekdays)
      allow(described_class).to receive(:holidays).and_return(holidays)
    end

    context 'when weekdays are empty' do
      let(:weekdays) { [] }

      context 'when holidays are empty' do
        let(:holidays) { [] }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'when holidays are not empty' do
        context 'when given date is present in holiday' do
          it 'returns false' do
            expect(subject).to be false
          end
        end

        context 'when given date is not a holiday' do
          let(:date) { Date.new(2015, 1, 2) }
          it 'returns true' do
            expect(subject).to be true
          end
        end
      end
    end

    context 'when weekdays are not empty' do
      context 'when holidays are empty' do
        let(:holidays) { [] }

        context 'when given date is weekday' do
          let(:date) { Date.new(2014, 12, 30) }

          it 'returns true' do
            expect(subject).to be true
          end
        end

        context 'when given date is not a weekday' do
          it 'returns false' do
            expect(subject).to be false
          end
        end
      end
    end
  end

  describe '#days_before' do
    subject { described_class.days_before(number, date) }
    let(:number) { 4 }
    let(:date) { Date.new(2015, 1, 5) }
    let(:weekdays) { [:mon, :tue, :wed, :thu, :fri] }
    let(:holidays) { [Date.new(2015, 1, 1)] }

    before do
      allow(described_class).to receive(:weekdays).and_return(weekdays)
      allow(described_class).to receive(:holidays).and_return(holidays)
    end

    context 'when number is positive' do
      let(:output_date) { Date.new(2014, 12, 29) }

      it 'returns the desired date' do
        expect(subject).to eq(output_date)
      end
    end

    context 'when number is negative' do
      let(:number) { -1 }
      it 'returns the given date' do
        expect(subject).to eq(date)
      end
    end
  end

  describe '#days_after' do
    subject { described_class.days_after(number, date) }

    let(:number) { 4 }
    let(:date) { Date.new(2015, 1, 5) }
    let(:weekdays) { [:mon, :tue, :wed, :thu, :fri] }
    let(:holidays) { [Date.new(2015, 1, 1)] }

    before do
      allow(described_class).to receive(:weekdays).and_return(weekdays)
      allow(described_class).to receive(:holidays).and_return(holidays)
    end

    context 'when number is positive' do
      let(:output_date) { Date.new(2015, 1, 9) }

      it 'returns the desired date' do
        expect(subject).to eq(output_date)
      end
    end

    context 'when number is negative' do
      let(:number) { -1 }

      it 'returns the given date' do
        expect(subject).to eq(date)
      end
    end
  end

  describe '#between' do
    subject { WorkCalendar.between(start_date, end_date) }

    let(:number) { 4 }
    let(:start_date) { Date.new(2015, 1, 5) }
    let(:end_date) { Date.new(2015, 1, 12) }
    let(:weekdays) { [:mon, :tue, :wed, :thu, :fri] }
    let(:holidays) { [Date.new(2015, 1, 1), Date.new(2015, 1, 9)] }

    before do
      allow(described_class).to receive(:weekdays).and_return(weekdays)
      allow(described_class).to receive(:holidays).and_return(holidays)
    end

    context 'when current_date less than end date' do
      let(:active_dates) do
        [
          Date.new(2015, 1, 5),
          Date.new(2015, 1, 6),
          Date.new(2015, 1, 7),
          Date.new(2015, 1, 8),
        ]
      end

      it 'returns array of active dates' do
        expect(subject).to eq(active_dates)
      end
    end

    context 'when current_date newer than end date' do
      let(:start_date) { Date.new(2015, 1, 15) }

      it 'returns empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when current_date is same as end date' do
      let(:start_date) { Date.new(2015, 1, 12) }

      it 'returns empty array' do
        expect(subject).to eq([])
      end
    end
  end
end
