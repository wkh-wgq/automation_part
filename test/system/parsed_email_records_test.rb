require "application_system_test_case"

class ParsedEmailRecordsTest < ApplicationSystemTestCase
  setup do
    @parsed_email_record = parsed_email_records(:one)
  end

  test "visiting the index" do
    visit parsed_email_records_url
    assert_selector "h1", text: "Parsed email records"
  end

  test "should create parsed email record" do
    visit parsed_email_records_url
    click_on "New parsed email record"

    fill_in "Data", with: @parsed_email_record.data
    fill_in "Email", with: @parsed_email_record.email
    fill_in "Inbound email", with: @parsed_email_record.inbound_email_id
    fill_in "Sent at", with: @parsed_email_record.sent_at
    fill_in "Type", with: @parsed_email_record.type
    click_on "Create Parsed email record"

    assert_text "Parsed email record was successfully created"
    click_on "Back"
  end

  test "should update Parsed email record" do
    visit parsed_email_record_url(@parsed_email_record)
    click_on "Edit this parsed email record", match: :first

    fill_in "Data", with: @parsed_email_record.data
    fill_in "Email", with: @parsed_email_record.email
    fill_in "Inbound email", with: @parsed_email_record.inbound_email_id
    fill_in "Sent at", with: @parsed_email_record.sent_at
    fill_in "Type", with: @parsed_email_record.type
    click_on "Update Parsed email record"

    assert_text "Parsed email record was successfully updated"
    click_on "Back"
  end

  test "should destroy Parsed email record" do
    visit parsed_email_record_url(@parsed_email_record)
    click_on "Destroy this parsed email record", match: :first

    assert_text "Parsed email record was successfully destroyed"
  end
end
