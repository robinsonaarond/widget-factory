class Session
  def self.set_user_on_session(user, session)


    p "+_+_+_+_+"
    pp user[:full_name]
    p "+_+_+_+_+_+_+"
    pp user

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
