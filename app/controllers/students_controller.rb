class StudentsController < ApplicationController
  before_action :authenticate_student!
  load_and_authorize_resource

  def show
    @courses = current_user.courses.includes(:image_attachment).to_a
    @enrollments = Enrollment.where(student_id: current_user.id).includes(:course).to_a
    # calculate progress of each course using chapter_completed in enrollments and total_chapters in courses
    @progress = {}
    @enrollments.each do |enrollment|
      @progress[enrollment.course_id] = (enrollment.chapters_completed.to_f/enrollment.course.total_chapters.to_f)*100
    end

  end
private
  def current_user
    current_instructor || current_student
  end
end
