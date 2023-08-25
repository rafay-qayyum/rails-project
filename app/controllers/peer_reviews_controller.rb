class PeerReviewsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :chapter
  load_and_authorize_resource :peer_review



  def create
    debugger
    @student = Student.where(id: params[:reviewee_id]).first
    if @student.nil?
      flash[:alert] = "Student doesn't exist"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    if ChapterResult.where(student_id: current_student, course_id: params[:course_id], chapter_id: params[:chapter_id]).empty?
      flash[:alert] = "You have never attempted this chapter"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    @reviewee_chapter_results=ChapterResult.where(student_id: params[:reviewee_id], course_id: params[:course_id], chapter_id: params[:chapter_id]).first
    if @reviewee_chapter_results.nil?
      flash[:alert] = "This Student has never attempted this chapter"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    if PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewee_id: params[:reviewee_id], reviewer_id: current_student).present?
      flash[:alert] = "You have already reviewed this submission"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    if PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewer_id: current_student).count >= 3
      flash[:alert] = "You have already reviewed 3 submissions"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end



    @peer_review = PeerReview.new(reviewer_id: current_student.id,
     reviewee_id: params[:reviewee_id], course_id: params[:course_id],
      chapter_id: params[:chapter_id], quiz_marks: params[:quiz_marks],
       assignment_marks: params[:assignment_marks], chapter_result_id: @reviewee_chapter_results.id)
    if @peer_review.save
      @reviews_of_stu=PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewee_id: params[:reviewee_id])
      if @reviews_of_stu.count == 3
        # calculate average marks
        avg_quiz_marks = @reviews_of_stu.average(:quiz_marks)
        avg_assignment_marks = @reviews_of_stu.average(:assignment_marks)
        @reviewee_chapter_results[:total_marks] = (avg_quiz_marks + avg_assignment_marks) / 2
        @reviewee_chapter_results[:is_reviewed] = true
        @reviewee_chapter_results.save
      end
      flash[:notice] = "Peer review created successfully"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    else
      flash[:alert] = "Peer review not created successfully"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]), status: :unprocessable_entity and return
    end
  end

  # function returns all the peer reviews of a student for a particular chapter
  def index
    @peer_reviews = PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewee_id: current_user.id)
    if @peer_reviews.empty?
      flash[:alert] = "No peer reviews found"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    @avg_quiz_marks = @peer_reviews.average(:quiz_marks)
    @avg_assignment_marks = @peer_reviews.average(:assignment_marks)
    @avg_total_marks = (@avg_quiz_marks + @avg_assignment_marks) / 2
  end

  def current_user
    current_student || current_instructor
  end

  private

end