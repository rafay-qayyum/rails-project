class ChaptersController < ApplicationController
  load_and_authorize_resource
  def index
    @course = Course.find(params[:course_id])
    @chapters = @course.chapters
  end

  def show
    begin
      @course = Course.find(params[:course_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
    begin
      @chapter = @course.chapters.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The chapter you are looking for could not be found"
      redirect_to course_path(@course)
    end
  end

  def new
    debugger
    begin
      @course = Course.find(params[:course_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
    @chapter = @course.chapters.new
  end

  def create
    begin
      @course = Course.find(params[:chapter][:course_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
    @chapter = @course.chapters.create(chapter_params)
    if @chapter.save
      flash[:notice] = "Chapter created successfully"
      redirect_to course_path(@course)
    else
      flash[:alert] = "Chapter not created successfully"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    begin
      @course = Course.find(params[:course_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The course you are looking for could not be found"
      redirect_to instructor_path(current_instructor)
    end
    begin
      @chapter = @course.chapters.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The chapter you are looking for could not be found"
      redirect_to course_path(@course)
    end
  end

  def update
    begin
      @chapter = Chapter.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The chapter you are looking for could not be found"
      redirect_to course_path(@course)
    end
    if @chapter.update(chapter_params)
      flash[:notice] = "Chapter updated successfully"
      redirect_to course_path(@chapter.course_id)
    else
      flash[:alert] = "Chapter not updated successfully"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @chapter = Chapter.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The chapter you are looking for could not be found"
      redirect_to course_path(@course)
    end
    @chapter.destroy
    redirect_to course_path(@chapter.course_id)
  end

private
  def chapter_params
    params.require(:chapter).permit(:name,:content,:quiz,:assignment)
  end

  def current_user
    current_student || current_instructor
  end
end
