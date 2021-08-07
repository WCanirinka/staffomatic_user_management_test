# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def user_changed
    archived_user = params[:archived_user]
    @user = params[:user]
    @action = params[:action]
    mail(to: archived_user.email, subject: 'User changed')
  end
end
