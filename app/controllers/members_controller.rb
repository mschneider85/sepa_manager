class MembersController < ApplicationController
  def confirm
    member = Member.find_by_token_for!(:confirmation, params[:token])
    return head(:not_found) unless member

    member.confirm!
  end
end
