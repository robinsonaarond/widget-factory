class ApplicationController < ActionController::Base
  before_action :set_user_on_session

  private

  # This is simply making a profile call and setting it on the session.
  # We are not checking for session against the CAS yet.
  def set_user_on_session
    response = Base.profile_request("#{Rails.application.config.base_profile_service_url}/#{params[:user_uuid]}", {nucleus_view: "partner_extended"})

    user = response[:data][0]

    Session.set_user_on_session(user, session)
  end
end
