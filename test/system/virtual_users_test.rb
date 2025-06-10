require "application_system_test_case"

class VirtualUsersTest < ApplicationSystemTestCase
  setup do
    @virtual_user = virtual_users(:one)
  end

  test "visiting the index" do
    visit virtual_users_url
    assert_selector "h1", text: "Virtual users"
  end

  test "should create virtual user" do
    visit virtual_users_url
    click_on "New virtual user"

    fill_in "Birthdate", with: @virtual_user.birthdate
    fill_in "Civ style", with: @virtual_user.civ_style
    fill_in "Domain", with: @virtual_user.domain
    fill_in "Email", with: @virtual_user.email
    fill_in "First name", with: @virtual_user.first_name
    fill_in "Gender", with: @virtual_user.gender
    fill_in "Last name", with: @virtual_user.last_name
    click_on "Create Virtual user"

    assert_text "Virtual user was successfully created"
    click_on "Back"
  end

  test "should update Virtual user" do
    visit virtual_user_url(@virtual_user)
    click_on "Edit this virtual user", match: :first

    fill_in "Birthdate", with: @virtual_user.birthdate
    fill_in "Civ style", with: @virtual_user.civ_style
    fill_in "Domain", with: @virtual_user.domain
    fill_in "Email", with: @virtual_user.email
    fill_in "First name", with: @virtual_user.first_name
    fill_in "Gender", with: @virtual_user.gender
    fill_in "Last name", with: @virtual_user.last_name
    click_on "Update Virtual user"

    assert_text "Virtual user was successfully updated"
    click_on "Back"
  end

  test "should destroy Virtual user" do
    visit virtual_user_url(@virtual_user)
    click_on "Destroy this virtual user", match: :first

    assert_text "Virtual user was successfully destroyed"
  end
end
