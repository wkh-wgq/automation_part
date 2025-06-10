require "test_helper"

class Sites::PokemonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sites_pokemon = sites_pokemons(:one)
  end

  test "should get index" do
    get sites_pokemons_url
    assert_response :success
  end

  test "should get new" do
    get new_sites_pokemon_url
    assert_response :success
  end

  test "should create sites_pokemon" do
    assert_difference("Sites::Pokemon.count") do
      post sites_pokemons_url, params: { sites_pokemon: { kana: @sites_pokemon.kana, nickname: @sites_pokemon.nickname, reg_password: @sites_pokemon.reg_password, registry_cellphone: @sites_pokemon.registry_cellphone, registry_fandi: @sites_pokemon.registry_fandi, registry_postcode: @sites_pokemon.registry_postcode, virtual_user_id: @sites_pokemon.virtual_user_id } }
    end

    assert_redirected_to sites_pokemon_url(Sites::Pokemon.last)
  end

  test "should show sites_pokemon" do
    get sites_pokemon_url(@sites_pokemon)
    assert_response :success
  end

  test "should get edit" do
    get edit_sites_pokemon_url(@sites_pokemon)
    assert_response :success
  end

  test "should update sites_pokemon" do
    patch sites_pokemon_url(@sites_pokemon), params: { sites_pokemon: { kana: @sites_pokemon.kana, nickname: @sites_pokemon.nickname, reg_password: @sites_pokemon.reg_password, registry_cellphone: @sites_pokemon.registry_cellphone, registry_fandi: @sites_pokemon.registry_fandi, registry_postcode: @sites_pokemon.registry_postcode, virtual_user_id: @sites_pokemon.virtual_user_id } }
    assert_redirected_to sites_pokemon_url(@sites_pokemon)
  end

  test "should destroy sites_pokemon" do
    assert_difference("Sites::Pokemon.count", -1) do
      delete sites_pokemon_url(@sites_pokemon)
    end

    assert_redirected_to sites_pokemons_url
  end
end
