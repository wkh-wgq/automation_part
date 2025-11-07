class PokemonController < ApplicationController
  def captcha
    captcha = Rails.cache.read("pokermon.#{params[:email]}.login_captcha")
    respond_to do |format|
      format.json { render json: { captcha: captcha } }
    end
  end

  def register_link
    register_link = Rails.cache.read("pokermon.#{params[:email]}.register_link")
    respond_to do |format|
      format.json { render json: { register_link: register_link } }
    end
  end
end
