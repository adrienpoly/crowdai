class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :username, :password, :password_confirmation,
        :phone_number, :country, :city, :first_name, :last_name, :hosting_institution_id,
        :email_public, :bio, :website, :github, :linkedin, :twitter)
    end

end
