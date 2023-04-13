class User
  def self.get_user(current_user_uuid)
    response = Base.profile_request("#{Rails.application.config.service_url[:profile_v3]}/nucleus/profile/#{current_user_uuid}", {nucleus_view: "partner_extended"})
    response[:data][0]
  end

  def self.get_office(current_user_office_uuid)
    response = Base.profile_request("#{Rails.application.config.service_url[:profile_v3]}/nucleus/office/#{current_user_office_uuid}", {nucleus_view: "partner_extended"})
    response[:data][0]
  end

  def self.get_company(current_user_company_uuid)
    response = Base.profile_request("#{Rails.application.config.service_url[:profile_v3]}/nucleus/company/#{current_user_company_uuid}", {nucleus_view: "partner_extended"})
    response[:data][0]
  end

  def self.get_board(current_user_board_uuid)
    response = Base.profile_request("#{Rails.application.config.service_url[:profile_v3]}/nucleus/board/#{current_user_board_uuid}", {nucleus_view: "partner_extended"})
    response[:data][0]
  end
end
