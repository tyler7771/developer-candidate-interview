require 'rspec'
require_relative '../scheduler'

# Tested that I was converting time correctly. Would have liked to write
# more tests but ran out of time. I'm going to right more tests and edit
# my PR

RSpec.describe Schedule do
  schedule = Schedule.new

  context 'convert_time' do
    it 'should convert "1/2 hour"' do
      expect(schedule.convert_time("1/2 hour")).to eq(30)
    end

    it 'should convert hours' do
      expect(schedule.convert_time("1 hour")).to eq(60)
      expect(schedule.convert_time("2 hour")).to eq(120)
      expect(schedule.convert_time("10 hour")).to eq(600)
    end

    it 'should convert hours and fraction' do
      expect(schedule.convert_time("1 1/2 hour")).to eq(90)
      expect(schedule.convert_time("1 hour 45 minutes")).to eq(105)
      expect(schedule.convert_time("2 hours 15 minutes")).to eq(135)
    end

    it 'should convert minutes' do
      expect(schedule.convert_time("15 minutes")).to eq(15)
      expect(schedule.convert_time("25 minutes")).to eq(25)
      expect(schedule.convert_time("45 minutes")).to eq(45)
    end
  end
end
