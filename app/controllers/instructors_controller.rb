class InstructorsController < ApplicationController
  before_action :authenticate_instructor!
  load_and_authorize_resource
  
  def show
    @instructor = current_instructor
    @courses = @instructor.courses
  end

private
  def current_user
    current_instructor || current_student
  end
end
