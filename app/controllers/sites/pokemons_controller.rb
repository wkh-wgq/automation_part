class Sites::PokemonsController < ApplicationController
  before_action :set_sites_pokemon, only: %i[ show edit update destroy ]

  # GET /sites/pokemons or /sites/pokemons.json
  def index
    @sites_pokemons = Sites::Pokemon.all
  end

  # GET /sites/pokemons/1 or /sites/pokemons/1.json
  def show
  end

  # GET /sites/pokemons/new
  def new
    @sites_pokemon = Sites::Pokemon.new
  end

  # GET /sites/pokemons/1/edit
  def edit
  end

  # POST /sites/pokemons or /sites/pokemons.json
  def create
    @sites_pokemon = Sites::Pokemon.new(sites_pokemon_params)

    respond_to do |format|
      if @sites_pokemon.save
        format.html { redirect_to @sites_pokemon, notice: "Pokemon was successfully created." }
        format.json { render :show, status: :created, location: @sites_pokemon }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sites_pokemon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/pokemons/1 or /sites/pokemons/1.json
  def update
    respond_to do |format|
      if @sites_pokemon.update(sites_pokemon_params)
        format.html { redirect_to @sites_pokemon, notice: "Pokemon was successfully updated." }
        format.json { render :show, status: :ok, location: @sites_pokemon }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sites_pokemon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/pokemons/1 or /sites/pokemons/1.json
  def destroy
    @sites_pokemon.destroy!

    respond_to do |format|
      format.html { redirect_to sites_pokemons_path, status: :see_other, notice: "Pokemon was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sites_pokemon
      @sites_pokemon = Sites::Pokemon.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sites_pokemon_params
      params.expect(sites_pokemon: [ :nickname, :kana, :registry_cellphone, :registry_postcode, :registry_fandi, :reg_password, :virtual_user_id ])
    end
end
