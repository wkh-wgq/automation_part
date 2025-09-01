require "test_helper"

class ParsedEmailRecordsControllerTest < ActionDispatch::IntegrationTest
  test "should get original_mail" do
    get parsed_email_records_original_mail_url
    assert_response :success
  end
end
