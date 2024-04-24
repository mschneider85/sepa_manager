class MemberMailer < ApplicationMailer
  layout false

  def confirmation_email
    @member = params[:member]

    I18n.with_locale(:de) do
      mail(to: @member.email, subject: "Dein Mitgliedsantrag // Bitte bestätigen")
    end
  end
end
