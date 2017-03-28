class UsersController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find_by_id(params[:id])
  end
end
