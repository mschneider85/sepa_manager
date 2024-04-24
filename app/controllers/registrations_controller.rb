class RegistrationsController < ApplicationController
  invisible_captcha only: :create, honeypot: :subtitle, on_timestamp_spam: :timestamp_spam

  def show
    @registration_form = RegistrationForm.new
  end

  def create
    @registration_form = RegistrationForm.new(registration_form_params)
    if @registration_form.save
      member = @registration_form.member
      MemberMailer.with(member: member).confirmation_email.deliver_later
      redirect_to danke_path
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def registration_form_params
    params.require(:registration_form).permit(
      :email,
      :firstname,
      :lastname,
      :address,
      :zip,
      :city,
      :annual_fee,
      :iban,
      :account_holder,
      :terms,
      :sepa_mandate
    )
  end

  def timestamp_spam
    flash.now[:error] = InvisibleCaptcha.timestamp_error_message
    @registration_form = RegistrationForm.new(registration_form_params)
    @registration_form.valid?
    render :show, status: :unprocessable_entity
  end
end
