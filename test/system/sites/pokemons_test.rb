require "application_system_test_case"

class Sites::PokemonsTest < ApplicationSystemTestCase
  setup do
    @sites_pokemon = sites_pokemons(:one)
  end

  test "visiting the index" do
    visit sites_pokemons_url
    assert_selector "h1", text: "Pokemons"
  end

  test "should create pokemon" do
    visit sites_pokemons_url
    click_on "New pokemon"

    fill_in "Kana", with: @sites_pokemon.kana
    fill_in "Nickname", with: @sites_pokemon.nickname
    fill_in "Reg password", with: @sites_pokemon.reg_password
    fill_in "Registry cellphone", with: @sites_pokemon.registry_cellphone
    fill_in "Registry fandi", with: @sites_pokemon.registry_fandi
    fill_in "Registry postcode", with: @sites_pokemon.registry_postcode
    fill_in "Virtual user", with: @sites_pokemon.virtual_user_id
    click_on "Create Pokemon"

    assert_text "Pokemon was successfully created"
    click_on "Back"
  end

  test "should update Pokemon" do
    visit sites_pokemon_url(@sites_pokemon)
    click_on "Edit this pokemon", match: :first

    fill_in "Kana", with: @sites_pokemon.kana
    fill_in "Nickname", with: @sites_pokemon.nickname
    fill_in "Reg password", with: @sites_pokemon.reg_password
    fill_in "Registry cellphone", with: @sites_pokemon.registry_cellphone
    fill_in "Registry fandi", with: @sites_pokemon.registry_fandi
    fill_in "Registry postcode", with: @sites_pokemon.registry_postcode
    fill_in "Virtual user", with: @sites_pokemon.virtual_user_id
    click_on "Update Pokemon"

    assert_text "Pokemon was successfully updated"
    click_on "Back"
  end

  test "should destroy Pokemon" do
    visit sites_pokemon_url(@sites_pokemon)
    click_on "Destroy this pokemon", match: :first

    assert_text "Pokemon was successfully destroyed"
  end
end
