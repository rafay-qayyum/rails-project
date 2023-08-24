class StudentsController < ApplicationController
  before_action :authenticate_student!
  load_and_authorize_resource

private
  def current_user
    current_instructor || current_student
  end
end
