class ChaptersController < ApplicationController
  load_and_authorize_resource
  def index
    @chapters=Chapter.find(params[:course_id])
  end
  def show
    @chapter=Chapter.find(params[:id])
  end
  def new
    @course=Course.find(params[:course_id])
    @chapter = @course.chapters.new
  end
  def create
    @course=Course.find(params[:chapter][:course_id])
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
    @chapter = Chapter.find(params[:id])
    @course = Course.find(params[:course_id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    if @chapter.update(chapter_params)
      flash[:notice] = "Chapter updated successfully"
      redirect_to course_path(@chapter.course_id)
    else
      flash[:alert] = "Chapter not updated successfully"
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @chapter = Chapter.find(params[:id])
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
