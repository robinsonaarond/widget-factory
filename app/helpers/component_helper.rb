module ComponentHelper
  def return_user
    User.get_office(session[:current_user][:uuid])
  end
  def return_office
    User.get_office(session[:current_user][:office_external_id])
  end
  def return_company
    User.get_office(session[:current_user][:company_external_id])
  end
  def return_board
    User.get_office(session[:current_user][:board_external_id])
  end
end
