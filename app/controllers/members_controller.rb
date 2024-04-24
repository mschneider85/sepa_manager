class MembersController < ApplicationController
  def confirm
    member = Member.find_by_token_for!(:confirmation, params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature => _e
    @invalid = true
  else
    member.confirm!
  end
end
