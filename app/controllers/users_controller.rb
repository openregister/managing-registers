class UsersController < ApplicationController

  before_action :set_user

  def index
    @users = User.all
  end

  def team
    @basic_users = User.joins(:team_members).where(team_members: { role: 'basic' })
    @advanced_users = User.joins(:team_members).where(team_members: { role: 'advanced' })
  end

  def custodians
    @users = User.joins(:team_members)
                 .where(team_members: { role: 'custodian' })
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = 'Your update has been successful'
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:full_name, :email, :role, :password, :password_confirmation, :current_password, registers: [])
  end

end
