class ChapterResultsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :chapter, through: :course
  load_and_authorize_resource :chapter_result

  def index
    # get all the submissions for the current chapter
    @submissions=ChapterResult.where( course_id: params[:course_id], chapter_id: params[:chapter_id])
                              .where.not(student_id: current_user.id).left_outer_joins(:peer_reviews)
                              .group('chapter_results.id')
                              .having('COUNT(peer_reviews.id) < 3')
    # remove submissions that have already been reviewed by current_user
    @submissions = @submissions.reject { |submission| submission.peer_reviews.where(reviewer_id: current_user.id).present? }
    # if Current user has already reviewed 3 submissions, then don't allow him to review any more
    if PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewer_id: current_student).count >= 3
      flash[:alert] = "You have already reviewed 3 submissions"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    # if there are no submissions to review, then redirect to course_chapter_path
    if @submissions.count == 0
      flash[:notice] = "No submissions to review"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
  end

  def create
    if ChapterResult.where(student_id: current_user.id, course_id: params[:course_id], chapter_id: params[:chapter_id]).present?
      flash[:alert] = "You have already attempted this chapter"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id])
    end
    @enrollment=current_user.enrollments.where(course_id: params[:course_id]).first
    @enrollment[:chapters_completed] += 1
    @chapter_result = ChapterResult.create(chapter_result_params.merge!({student_id: current_user.id}))
    # use transaction to ensure that either both or none of the operations are performed
    is_successful = false
    ActiveRecord::Base.transaction do
      begin
        @enrollment.save!
        @chapter_result.save!
        is_successful = true
      rescue
        is_successful = false
      end
    end
    # if the transaction was successful, then display the success message
    if is_successful == true
      flash[:notice] = "Chapter result created successfully"
      redirect_to course_chapter_path(@chapter.course_id, @chapter.id)
    else
      flash[:alert] = "Chapter result not created successfully"
      render course_chapter_path(@chapter.course_id, @chapter.id), status: :unprocessable_entity
    end
  end

  # NOT BEING USED
  def destroy
    @chapter_result = ChapterResult.find(params[:id])
    @chapter_result.destroy
    redirect_to course_chapter_path(@chapter_result.chapter.course_id, @chapter_result.chapter_id)
  end

private
  def chapter_result_params
    params.permit(:attempted_assignment, :attempted_quiz, :chapter_id, :course_id)
  end

  # Arguments: None
  # Returns: Student or Instructor object
  # Description: Returns the current user object
  def current_user
    current_student || current_instructor
  end
end
