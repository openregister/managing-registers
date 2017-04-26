class HomeController < ApplicationController
  def index
  end

  def select_register
    if params[:register][:register] == "country"
      redirect_to countries_path
    elsif params[:register][:register] == "territory"
      redirect_to territories_path
    elsif params[:register][:register] == "local_authority_eng"
      redirect_to local_authority_engs_path
    elsif params[:register][:register] == "local_authority_type"
      redirect_to local_authority_types_path
    else
      redirect_to root_path
    end
  end
end
