class HomeController < ApplicationController
  def index
  end

  def select_register
    if params[:register] == "countries"
      redirect_to countries_path
    elsif params[:register] == "territories"
      redirect_to territories_path
    elsif params[:register] == "local_authority_engs"
      redirect_to local_authority_engs_path
    elsif params[:register] == "local_authority_types"
      redirect_to local_authority_types_path
    else
      redirect_to root_path
    end
  end
end
