class CaptchaController < ApplicationController
  def show
    captcha = Rails.cache.read("pokermon.#{params[:email]}.login_captcha")
    respond_to do |format|
      format.json { render json: { captcha: captcha } }
    end
  end
end
