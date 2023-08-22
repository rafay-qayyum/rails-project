class CoursesController < ApplicationController
  load_and_authorize_resource :courses, through: :instructors

  def index
    @courses=Course.all
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
    debugger
    begin
      @course = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to root_path(current_user)
    end
  end

  def edit
    begin
      @course = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
  end

  def update
    begin
      @course = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
    if @course.update(course_params)
      flash[:notice] = "Course updated successfully"
      redirect_to course_path(@course)
    else
      flash[:alert] = "Course not updated successfully"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @course = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
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
