class CoursesController < ApplicationController
  def new
    @instructor = Instructor.find(current_instructor.id)
    @course = @instructor.courses.new
  end
  def create
    @instructor = Instructor.find(current_instructor.id)
    @course=@instructor.courses.create(course_params)
    if @course.save
      flash[:notice] = "Course created successfully"
      redirect_to instructor_path(@instructor)
    else
      flash[:alert] = "Course not created successfully"
      render :new, status: :unprocessable_entity
    end
  end
  def show
    @course = Course.find(params[:id])
  end
private
  def course_params
    params.require(:course).permit(:title,:description,:price,:language,:requirements,:image)
  end
end
