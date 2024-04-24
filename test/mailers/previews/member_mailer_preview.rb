# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview
  def confirmation_email
    MemberMailer.with(member: Member.first).confirmation_email
  end
end
