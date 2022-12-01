class ApplicationController < ActionController::Base
  before_action :set_user_on_session

  private

  def set_user_on_session
    response = Base.profile_request("#{Rails.application.config.base_profile_service_url}/#{params[:user_uuid]}", {nucleus_view: "partner_extended"})

    user = response[:data][0]

    h = {
      full_name: user[:full_name],
      uuid: user[:uuid],
      mls_number: user[:mls_number],
      nrds_number: user[:nrds_number],
      member_status: user[:member_status],
      subscription_status: user[:subscription_status],
      member_role: user[:member_role],
      office_external_id: user[:office][:office_external_id],
      company_external_id: user[:company][:company_external_id],
      board_external_id: user[:board][:board_external_id],
      board_mls_id: user[:board][:mls_id],
    }

    session[:current_user] = h
  end
end
