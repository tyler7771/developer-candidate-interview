# Created this class to create instructor objects and convert max time
# and class duration to minutes rather than a string.

class Instructor
  attr_reader :start_date, :end_date, :start_time, :end_time, :schedule,
  :group_max, :group_duration, :private_max, :private_duration

  def initialize(instructor)
    @start_date = Date.parse(instructor['Start Date'])
    @end_date = Date.parse(instructor['End Date'])
    @start_time = DateTime.parse(instructor['Start Time'])
    @end_time = DateTime.parse(instructor['End Time'])
    @schedule = []
    @group_max = 0
    @group_duration = 0
    @private_max = 0
    @private_duration = 0
  end

  def max_and_duration(instructor)
    training_type = instructor['Training Type'].split(' ')[0]

    if training_type == 'Group'
      @group_max = instructor['Max Participants'].to_i
      @group_duration = convert_time(instructor['Duration'])
    else
      @private_max = instructor['Max Participants'].to_i
      @private_duration = convert_time(instructor['Duration'])
    end
  end

  def convert_time(time)
    time = time.split(' ')

    if time[1].slice(0,4) == 'hour' && time[0] == '1/2'
      return 30
    elsif time.length === 3 && time[1] == '1/2'
      return hours_to_minutes(time[0].to_i) + 30
    elsif time.length == 4
      return hours_to_minutes(time[0].to_i) + time[2].to_i
    elsif time[1].slice(0,4) == 'hour'
      return hours_to_minutes(time[0].to_i)
    else
      return time[0].to_i
    end
  end

  def hours_to_minutes(hours)
    total = 0
    while hours > 0
      total += 60
      hours -= 1
    end
    total
  end
end
