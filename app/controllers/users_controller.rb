class UsersController < ApplicationController
  before_action :set_paper_trail_whodunnit, only: %i[archive unarchive]

  STATE_FILTERS = %w[archived unarchived].freeze
  def index
    user_state = params[:state]

    render jsonapi: user_state.blank ? User.all : User.send(user_state.to_s) if validate_state!(state)
  end

  def archive
    archived_user = User.find_by(id: params[user_id])
    archived_user.update(archived: true)
    UserMailer.with(archived_user: archived_user, user: current_user, action: 'archive').user_changed.deliver_now

    render jsonapi: archived_user
  end

  def unarchive
    archived_user = User.find_by(id: params[user_id])
    archived_user.update(archived: false)
    UserMailer.with(archived_user: archived_user, user: current_user, action: 'unarchive').user_changed.deliver_now

    render jsonapi: archived_user
  end

  def validate_state!(user_state)
    return if user_state.blank?

    unless STATE_FILTERS.include?(user_state)
      render json: 'Error', status: unprocessed_entity
      return false
    end
    true
  end
end
