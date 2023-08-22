class CoursesController < ApplicationController
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
    begin
      @course = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
  end

private
  def course_params
    params.require(:course).permit(:title,:description,:price,:language,:requirements,:image)
  end
end
