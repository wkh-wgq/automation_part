require "test_helper"

class ParsedEmailRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @parsed_email_record = parsed_email_records(:one)
  end

  test "should get index" do
    get parsed_email_records_url
    assert_response :success
  end

  test "should get new" do
    get new_parsed_email_record_url
    assert_response :success
  end

  test "should create parsed_email_record" do
    assert_difference("ParsedEmailRecord.count") do
      post parsed_email_records_url, params: { parsed_email_record: { data: @parsed_email_record.data, email: @parsed_email_record.email, inbound_email_id: @parsed_email_record.inbound_email_id, sent_at: @parsed_email_record.sent_at, type: @parsed_email_record.type } }
    end

    assert_redirected_to parsed_email_record_url(ParsedEmailRecord.last)
  end

  test "should show parsed_email_record" do
    get parsed_email_record_url(@parsed_email_record)
    assert_response :success
  end

  test "should get edit" do
    get edit_parsed_email_record_url(@parsed_email_record)
    assert_response :success
  end

  test "should update parsed_email_record" do
    patch parsed_email_record_url(@parsed_email_record), params: { parsed_email_record: { data: @parsed_email_record.data, email: @parsed_email_record.email, inbound_email_id: @parsed_email_record.inbound_email_id, sent_at: @parsed_email_record.sent_at, type: @parsed_email_record.type } }
    assert_redirected_to parsed_email_record_url(@parsed_email_record)
  end

  test "should destroy parsed_email_record" do
    assert_difference("ParsedEmailRecord.count", -1) do
      delete parsed_email_record_url(@parsed_email_record)
    end

    assert_redirected_to parsed_email_records_url
  end
end
