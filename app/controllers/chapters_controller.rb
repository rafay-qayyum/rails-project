class ChaptersController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :chapter, through: :course

  def index
    @course = Course.find(params[:course_id])
    @chapters = @course.chapters
  end

  def show

  end

  def new
    @chapter = @course.chapters.new
  end

  def create
    if @chapter.save
      flash[:notice] = "Chapter created successfully"
      redirect_to course_path(@course)
    else
      flash[:alert] = "Chapter not created successfully"
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update
    if @chapter.save
      flash[:notice] = "Chapter updated successfully"
      redirect_to course_path(@chapter.course_id)
    else
      flash[:alert] = "Chapter not updated successfully"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chapter.destroy
    redirect_to course_path(@chapter.course_id)
  end

  def current_user
    current_student || current_instructor
  end

private

  def chapter_params
    params.require(:chapter).permit(:name,:content,:quiz,:assignment)
  end
end
