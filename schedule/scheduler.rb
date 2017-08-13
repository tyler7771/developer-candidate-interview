require_relative 'instructor'
require_relative 'student'
require_relative 'lesson'
require 'csv'
require 'byebug'

class Schedule
  attr_reader :db

  def initialize
    @users = {}
    @lessons = []
  end

  # parses csv files, creates instructors, and checks input. It then puts
  # out a success or conflicts.
  
  def parse_file(file, type)
    parsed = []

    csv_text = File.read(file)
    csv = CSV.parse(csv_text, :headers => true)

    csv.each do |row|
      name = row['Name'].downcase.gsub(/[ ]/, '_')

      if type == 'instructor'
        if @users[name].nil?
          instructor = Instructor.new(row)
          instructor.max_and_duration(row)
          @users[name] = instructor
        else
          @users[name].max_and_duration(row)
        end
      else
        if @users[name].nil?
          student = Student.new(row)
          @users[name] = student
        end

        lesson = self.find_lesson(row) || Lesson.new(row)
        student = @users[name]
        instructor = @users[lesson.instructor.gsub(/[ ]/, '_')]

        conflicts = lesson.check_availability(instructor, student)
        if conflicts.length == 0
          student.schedule << lesson
          instructor.schedule << lesson
          @lessons << lesson
          puts ""
          puts "Request ID: #{row['Request ID']}"
          puts "Successful Booking"
        else
          puts ""
          puts "Request ID: #{row['Request ID']}"
          puts "Reason for Conflict: #{conflicts}"
          puts lesson.students
        end
      end
    end
  end

  # finds an existing lesson
  def find_lesson(lesson)
    @lessons.each do |other_lesson|
      if Date.parse(lesson['Start Date']) == other_lesson.start_date &&
        Date.parse(lesson['End Date']) == other_lesson.end_date &&
          lesson['With'].downcase == other_lesson.instructor &&
            DateTime.parse(lesson['Start Time']) == other_lesson.start_time
              return other_lesson
      end
    end
    nil
  end
end

s = Schedule.new
s.parse_file('./instructor_availability.csv', 'instructor')
s.parse_file('./input.csv', 'student')
