class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit

  protected

  def user_for_paper_trail
    admin_user_signed_in? ? current_admin_user.id : "Unknown user"
  end

  def set_admin_locale
    I18n.locale = :en
  end
end
