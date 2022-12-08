class ApplicationController < ActionController::Base
  before_action :clear_session, :check_valid_session

  private

  # This is simply making a profile call and setting it on the session.
  # We are not checking for session against the CAS yet.
  def check_valid_session
    if params[:session_id]

      auth_response = Resource::Auth.poll(params[:session_id])

      unless auth_response.nil?
        response = Base.profile_request("#{Rails.application.config.base_profile_service_url}/profile/#{params[:user_uuid]}")
        user = response[:data][0]
        Session.set_user_on_session(user, session)
      end
    end
  end

  def clear_session
    session.clear
  end
end
