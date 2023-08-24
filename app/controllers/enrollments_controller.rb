class EnrollmentsController < ApplicationController
  def create
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
    @enrollment = Enrollment.find(params[:id])
    @enrollment.destroy
    redirect_to course_path(@enrollment.course_id)
  end

private
  def enrollment_params
    params.permit(:student_id, :course_id)
  end

  def current_user
    current_student || current_instructor
  end
end
