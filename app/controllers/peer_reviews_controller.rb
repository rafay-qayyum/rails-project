class PeerReviewsController < ApplicationController
  load_and_authorize_resource :course
  load_and_authorize_resource :chapter, through: :course
  def index
    @submissions = ChapterResult.where(course_id: params[:course_id], chapter_id: params[:chapter_id]).where.not(student_id: current_user.id)
  end

  def current_user
    current_student || current_instructor
  end
end
