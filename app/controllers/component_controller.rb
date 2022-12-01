class ComponentController < ApplicationController
  include Cachable

  before_action :return_agent
  caches_action :name, expires_in: default_cache_time

  def name
    # Looks for namespaced component first.
    obj = begin
      Object.const_get("#{params[:name].camelize}::#{params[:name].camelize}Component").new
    rescue
      Object.const_get("#{params[:name].camelize}Component").new
    end

    render(obj)
  end

  private

  # Temporary method to make sure action caching
  # is working properly. This will be swapped out
  # for session verification.
  def put_time
    p "+_+_+_+_+_+"
    p Time.now
    p Rails.application.config.base_profile_service_url
  end

  def return_agent
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
