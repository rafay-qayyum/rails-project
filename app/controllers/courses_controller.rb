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
  def edit
    @course = Course.find(params[:id])
  end
  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      flash[:notice] = "Course updated successfully"
      redirect_to course_path(@course)
    else
      flash[:alert] = "Course not updated successfully"
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to instructor_path(current_instructor)
  end
private
  def course_params
    params.require(:course).permit(:title,:description,:price,:language,:requirements,:image)
  end
end
