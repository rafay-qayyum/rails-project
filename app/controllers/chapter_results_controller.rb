class ChapterResultsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :chapter, through: :course
  load_and_authorize_resource :chapter_result


  def index
    @submissions=ChapterResult.where( course_id: params[:course_id], chapter_id: params[:chapter_id])
                              .where.not(student_id: current_user.id).left_outer_joins(:peer_reviews)
                              .group('chapter_results.id')
                              .having('COUNT(peer_reviews.id) < 3')
    # remove submissions that have already been reviewed by current_user
    @submissions = @submissions.reject { |submission| submission.peer_reviews.where(reviewer_id: current_user.id).present? }
    if PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewer_id: current_student).count >= 3
      flash[:alert] = "You have already reviewed 3 submissions"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    if @submissions.count == 0
      flash[:notice] = "No submissions to review"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
  end

  def create
    if ChapterResult.where(student_id: current_user.id, course_id: params[:course_id], chapter_id: params[:chapter_id]).present?
      flash[:alert] = "You have already attempted this chapter"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id])
    else
      @enrollment=current_user.enrollments.where(course_id: params[:course_id]).first
      @enrollment[:chapters_completed] += 1
      @chapter_result = ChapterResult.create(chapter_result_params.merge!({student_id: current_user.id}))
      if @chapter_result.save and @enrollment.save
        flash[:notice] = "Chapter result created successfully"
        redirect_to course_chapter_path(@chapter.course_id, @chapter.id)
      else
        flash[:alert] = "Chapter result not created successfully"
        render course_chapter_path(@chapter.course_id, @chapter.id), status: :unprocessable_entity
      end
  end
  end

  def destroy
    @chapter_result = ChapterResult.find(params[:id])
    @chapter_result.destroy
    redirect_to course_chapter_path(@chapter_result.chapter.course_id, @chapter_result.chapter_id)
  end

private
  def chapter_result_params
    params.permit(:attempted_assignment, :attempted_quiz, :chapter_id, :course_id)
  end

  def current_user
    current_student || current_instructor
  end
end
