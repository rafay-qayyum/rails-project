class CoursesController < ApplicationController
  load_and_authorize_resource

  def index
    @courses = Course.all
  end

  def new
    @instructor = current_instructor
    @course = @instructor.courses.new
  end

  def create
    @instructor = current_instructor
    @course = @instructor.courses.create(course_params)
    if @course.save
      flash[:notice] = "Course created successfully"
      redirect_to instructor_path(@instructor)
    else
      flash[:alert] = "Course not created successfully"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @message = nil
    if current_user.is_a?(Student)
      @enrollment = Enrollment.where(student_id: current_user.id, course_id: params[:id]).first
      # get grade if enrollment exists, if grade is O then student has not completed the course
      @grade = @enrollment.present? ? @enrollment.grade : nil
      if @enrollment.present?
        if @grade == 'O'
          @message = 'Pending'
        else
          @message = "#{@grade}"
        end
      end
    end
  end

  def edit

  end

  def update
    if @course.update(course_params)
      flash[:notice] = "Course updated successfully"
      redirect_to course_path(@course)
    else
      flash[:alert] = "Course not updated successfully"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    redirect_to instructor_path(current_instructor)
  end

private
  def course_params
    params.require(:course).permit(:title,:description,:price,:language,:requirements,:image)
  end

  def current_user
    current_student || current_instructor
  end
end
