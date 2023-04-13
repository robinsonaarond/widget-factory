class ApplicationController < ActionController::Base
  before_action :clear_session, unless: -> { request.headers["Authorization"].present? }
  before_action :jwt_authenticate, :check_valid_session

  private

  # This is simply polling the auth service to make sure there is a valid session.
  # Other than this, there is no session management in this applicatino.
  # The assumption is that users need to be logged in to another Moxi entity
  # which will consime this content.
  def check_valid_session
    if params[:session_id]

      auth_response = Resource::Auth.poll(params[:session_id])

      unless auth_response.nil?
        user_uuid = JSON.parse(auth_response, symbolize_names: true)[:vals][:context_user_uuid]
        set_user(user_uuid)
      end
    end
  end

  def clear_session
    session.clear
  end

  def set_user(uuid)
    response = Base.profile_request("#{Rails.application.config.service_url[:profile_v3]}/nucleus/profile/#{uuid}")
    user = response[:data][0]
    Session.set_user_on_session(user, session)
  end

  def jwt_authenticate
    return unless request.headers["Authorization"].present?
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    begin
      decoded = JsonWebToken.decode(token)
      set_user(decoded["uuid"])
    rescue ActiveRecord::RecordNotFound => e
      render json: {errors: e.message}, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: {errors: e.message}, status: :unauthorized
    end
  end
end
