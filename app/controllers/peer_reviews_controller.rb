class PeerReviewsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :chapter
  authorize_resource :peer_review

  def create
    @student = Student.where(id: params[:reviewee_id]).first
    if @student.nil?
      flash[:alert] = "Student doesn't exist"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    if ChapterResult.where(student_id: current_student, course_id: params[:course_id], chapter_id: params[:chapter_id]).empty?
      flash[:alert] = "You have never attempted this chapter"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end
    @reviewee_chapter_result=ChapterResult.where(student_id: params[:reviewee_id], course_id: params[:course_id], chapter_id: params[:chapter_id]).first
    if @reviewee_chapter_result.nil?
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

    # create the object
    @peer_review = PeerReview.new(reviewer_id: current_student.id,
     reviewee_id: params[:reviewee_id], course_id: params[:course_id],
      chapter_id: params[:chapter_id], quiz_marks: params[:quiz_marks],
       assignment_marks: params[:assignment_marks], chapter_result_id: @reviewee_chapter_result.id)
    is_successful = false
    # use transaction to ensure that either all or none of the operations are performed
    is_successful = false
    ActiveRecord::Base.transaction do
      begin
        @peer_review.save
        # get all the reviews of the student
        @reviews_of_stu=PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewee_id: params[:reviewee_id])
        if @reviews_of_stu.count == 3
          # calculate average marks
          avg_quiz_marks = @reviews_of_stu.average(:quiz_marks)
          avg_assignment_marks = @reviews_of_stu.average(:assignment_marks)
          @reviewee_chapter_result[:is_reviewed] = true
          @reviewee_chapter_result[:total_marks] = (avg_assignment_marks + avg_assignment_marks)/2.0
          @reviewee_chapter_result.save
          @completed_chapters = ChapterResult.where(student_id: params[:reviewee_id], course_id: params[:course_id])
          if @completed_chapters.count >= @course.total_chapters
            @enrollment = @course.enrollments.where(student_id: params[:reviewee_id]).first
            @enrollment[:grade] = calculate_grade(@completed_chapters.average(:total_marks))
            @enrollment.save
          end
        end
          is_successful = true
      rescue
        is_successful = false
      end
    end
    if is_successful == true
      flash[:notice] = "Peer review created successfully"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    else
      flash[:alert] = "Peer review not created successfully"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]), status: :unprocessable_entity and return
    end
  end

  # function returns all the peer reviews of a student for a particular chapter
  def index
    @peer_reviews = PeerReview.where(course_id: params[:course_id], chapter_id: params[:chapter_id], reviewee_id: current_user.id).to_a
    if @peer_reviews.empty?
      flash[:alert] = "No peer reviews found"
      redirect_to course_chapter_path(params[:course_id], params[:chapter_id]) and return
    end

    @avg_quiz_marks = average(@peer_reviews.pluck(:quiz_marks))
    @avg_assignment_marks = average(@peer_reviews.pluck(:assignment_marks))
    @avg_total_marks = (@avg_quiz_marks + @avg_assignment_marks) / 2
    if @peer_reviews.count<3
      @message = "You need #{3-@peer_reviews.count} review(s) to complete this chapter."
    else
      @message = "You have completed this chapter."
    end
  end

private
  def calculate_grade(score)
    if score >= 90
      return "A+"
    elsif score >= 85
      return "A"
    elsif score >= 80
      return "B+"
    elsif score >= 75
      return "B"
    elsif score >= 70
      return "C+"
    elsif score >= 65
      return "C"
    elsif score >= 60
      return "D+"
    elsif score >= 55
      return "D"
    else
      return "F"
    end
  end

  def average(marks)
    return marks.sum/marks.count
  end

  # Arguments: None
  # Returns: Student or Instructor object
  # Description: Returns the current user object
  def current_user
    current_student || current_instructor
  end
end
