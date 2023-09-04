class InstructorsController < ApplicationController
  before_action :authenticate_instructor!
  load_and_authorize_resource

  def show
    @instructor = current_instructor
    @courses = @instructor.courses
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
private
  # Arguments: None
  # Returns: Student or Instructor object
  # Description: Returns the current user object
  def current_user
    current_instructor || current_student
  end
end
