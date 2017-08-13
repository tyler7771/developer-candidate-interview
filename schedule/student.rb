# Creates a student object to track schedule

class Student
  attr_reader :schedule

  def initialize(instructor)
    @schedule = []
  end
end
