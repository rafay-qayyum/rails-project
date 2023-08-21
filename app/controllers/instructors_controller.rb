class InstructorsController < ApplicationController
  def show
    @instructor = Instructor.find(current_instructor.id)
    @courses = @instructor.courses
  end
end
