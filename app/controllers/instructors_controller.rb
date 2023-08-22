class InstructorsController < ApplicationController
  def show
    @instructor = current_instructor
    @courses = @instructor.courses
  end
end
