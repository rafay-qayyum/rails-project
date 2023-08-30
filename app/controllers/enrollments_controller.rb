class EnrollmentsController < ApplicationController
  load_and_authorize_resource

  def create
    if Enrollment.where(student_id: current_user.id, course_id: params[:course_id]).present?
      flash[:notice] = "You have already enrolled in this course"
      redirect_to course_path(params[:course_id]) and return
    end
    @enrollment = current_user.enrollments.new(enrollment_params)
    if @enrollment.save
      flash[:notice] = "Enrollment created successfully"
      redirect_to course_path(@enrollment.course_id, @enrollment)
    else
      flash[:alert] = "Enrollment not created successfully"
      render 'courses/show', status: :unprocessable_entity
    end
  end

  def destroy
    if !(Enrollment.where(student_id: current_user.id, course_id: params[:course_id]).present?)
      flash[:notice] = "You are not enrolled in this course"
      redirect_to course_path(params[:course_id]) and return
    end
    @enrollment.destroy
    @chapter_results = ChapterResult.where(student_id: current_user.id, course_id: params[:course_id])
    if !@chapter_results.nil?
      @chapter_results.destroy_all
    end
    redirect_to course_path(@enrollment.course_id)
  end

private
  def enrollment_params
    params.permit(:student_id, :course_id)
  end

  # Arguments: None
  # Returns: Student or Instructor object
  # Description: Returns the current user object
  def current_user
    current_student || current_instructor
  end
end
