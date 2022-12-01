class WelcomeController < ApplicationController
  def index
  end

  def user_session
    render json: session
  end
end
