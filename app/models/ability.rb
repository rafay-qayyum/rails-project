# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    # if user is not logged in, redirect to login page
    if user.blank?
      cannot :manage, :all
      return
    end

    # if user is admin, allow all actions
    if user.is? :admin
      can :manage, :all
    end

    if user.is? :instructor
      can :manage, Course, instructor_id: user.id
      can :manage, Chapter, course: { instructor_id: user.id }
      can :manage, Instructor, id: user.id
      can :read, Course
    end

    if user.is? :student
      can :read, Course
      can :read, Instructor
      can :manage, Student, id: user.id
      can :create , Enrollment
      can :destroy , Enrollment, student_id: user.id
      can :read, Chapter, course: {enrollments: {student_id: user.id}}
      can :create, ChapterResult, chapter: {course: {enrollments: {student_id: user.id}}}
      can :read , ChapterResult
      can :manage, PeerReview
      can [:search] , Course
    end
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
