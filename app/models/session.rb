class Session
  def self.set_user_on_session(user, session)
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
      company_uuid: user[:company][:company_uuid],
      board_external_id: user[:board][:board_external_id],
      board_mls_id: user[:board][:mls_id],
      board_uuid: user[:board][:board_uuid],
      office_uuid: user[:office][:office_uuid],
    }

    session[:current_user] = h
  end
end
