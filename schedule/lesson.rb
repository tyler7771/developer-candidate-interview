# Chose to create this class to handle logic for creating lessons and
# checking if there are conflicts.

class Lesson
  attr_reader :schedule
  attr_reader :id, :students, :instructor, :type, :start_date, :end_date,
  :start_time, :end_time

  def initialize(lesson)
    @id = lesson['Request ID']
    @students = []
    @instructor = lesson['With'].downcase
    @type = lesson['Training Type'].split(' ')[0]
    @start_date = Date.parse(lesson['Start Date'])
    @end_date = Date.parse(lesson['End Date'])
    @start_time = DateTime.parse(lesson['Start Time'])
    @end_time = DateTime.parse(lesson['End Time'])
  end

  # Handles main checking for conflicts
  def check_availability(instructor, student)
    conflicts = []

    return ['other'] if instructor.nil?
    if self.type == 'Group'
      conflicts << 'Class Full' if self.full_class?(instructor)
    else
      conflicts << "instructor not available"
    end
    conflicts << 'Requested Class Time Too Long' if self.class_too_long?(instructor)

    if self.type == 'Group'
      self.students << student
      return conflicts
    else
      [instructor, student].each do |user|
        if self.check_conflict(user)
          conflicts << "#{user} not available"
        end
      end
    end

    conflicts
  end

  def check_times(lesson)
    check_one = (self.start_time - lesson.end_time)
    check_two = (lesson.start_time - self.end_time)

    return check_one * check_two >= 0
  end

  def check_conflict(user)
    user.schedule.each do |lesson|
      check_one = (self.start_date - lesson.end_date)
      check_two = (lesson.start_date - self.end_date)

      if check_one * check_two >= 0
        if check_times(lesson)
          true
        end
      end
    end
    false
  end

  def full_class?(instructor)
    return true if self.students.length == instructor.group_max
    false
  end

  def private_class?(instructor)
    return true if self.students.length == instructor.private_max
    false
  end

  def class_too_long?(instructor)
    class_length = ((self.end_time - self.start_time) * 24 * 60).to_i

    if self.type == 'Group'
      return true if class_length > instructor.group_duration
    else
      return true if class_length > instructor.private_duration
    end
    false
  end

end
