class MemberMailer < ApplicationMailer
  layout false

  def confirmation_email
    @member = params[:member]
    mail(to: @member.email, subject: "Dein Mitgliedsantrag // Bitte bestätigen")
  end
end
