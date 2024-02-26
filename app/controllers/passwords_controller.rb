class PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_password, only: [:edit, :update, :show, :destroy]
  before_action :require_editor_privileges, only: [:edit, :update]
  before_action :require_owner_privileges, only: [:destroy]

  # /passwords
  def index
    @passwords = current_user.passwords
  end

  # /passwords/new
  def new
    @password = Password.new
  end

  # POST /passwords
  def create
    @password = Password.new(password_params)
    @password.user_passwords.new(user: current_user, role: :owner)

    if @password.save
      redirect_to @password
    else
      render :new, status: :unprocessable_entity
    end
  end

  # /passwords/:id
  def show

  end

  # /passwords/:id/edit
  def edit

  end

  # POST /passwords/:id
  def update
    if @password.update(password_params)
      redirect_to @password
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @password.destroy
    redirect_to passwords_path
  end

  private

  def password_params
    params.require(:password).permit(:url, :username, :password)
  end

  def set_password
    @password = current_user.passwords.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
  end

  def require_editor_privileges
    redirect_to @password unless @password.editable_by?(current_user)
  end

  def require_owner_privileges
    redirect_to @password unless @password.owned_by?(current_user)
  end
end
