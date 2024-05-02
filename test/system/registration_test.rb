require "application_system_test_case"

class RegistrationTest < ApplicationSystemTestCase
  setup do
    InvisibleCaptcha.init!
    InvisibleCaptcha.timestamp_threshold = 1
  end

  test "user can submit registration form" do
    visit registration_path

    # Continue filling in the form fields while
    # the sleep is happening for InvisibleCaptcha
    sleep_thread = Thread.new { sleep InvisibleCaptcha.timestamp_threshold }

    fill_in "Vorname", with: "John"
    fill_in "Nachname", with: "Doe"
    fill_in "Straße, Hausnummer", with: "123 Main St"
    fill_in "PLZ", with: "12345"
    fill_in "Ort", with: "City"
    fill_in "E-Mail", with: "john@example.com"
    fill_in "Jahresbeitrag", with: "20"
    fill_in "IBAN", with: "DE02120300000000202051"
    fill_in "Kontoinhaber", with: "John Doe"
    check "Ich ermächtige den Förderverein Güntherscher Kindergarten e.V., Zahlungen von meinem Konto mittels Lastschrift einzuziehen. Zugleich weise ich mein Kreditinstitut an, die vom Förderverein Güntherscher Kindergarten e.V. auf mein Konto gezogenen Lastschriften einzulösen."
    check "Ich habe die Datenschutzerklärung gelesen und stimme ihr zu. Mit der Verwendung der oben genannten Daten durch den Förderverein zum Zwecke der Mitgliederverwaltung und -information sowie der Beitragserhebung erkläre ich mich hiermit einverstanden."

    sleep_thread.join

    click_button "SENDEN"

    assert_text "Dein Mitgliedsantrag wurde übermittelt."

    assert_enqueued_emails 1
  end

  test "user can confirm registration" do
    member = members(:one).dup
    member.save!
    link = confirm_member_url(token: member.generate_token_for(:confirmation))

    visit link

    assert_text "Deine Anmeldung wurde erfolgreich bestätigt."
  end

  test "user can't confirm registration twice" do
    member = members(:one).dup
    member.save!
    link = confirm_member_url(token: member.generate_token_for(:confirmation))

    visit link
    assert_text "Deine Anmeldung wurde erfolgreich bestätigt."

    visit link
    assert_text "Deine Anmeldung wurde bereits bestätigt."
  end

  test "user can't confirm registration with invalid token" do
    visit confirm_member_url(token: "invalid")
    assert_text "Deine Anmeldung wurde bereits bestätigt."
  end
end
