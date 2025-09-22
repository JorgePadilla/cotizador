class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Create organization first
    organization = Organization.create!(organization_params.merge(language: "en"))
    @user.organization = organization

    if @user.save
      @session = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to root_path, notice: "Welcome! You have signed up successfully."
    else
      # Clean up organization if user fails to save
      organization.destroy if organization.persisted?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end

  def organization_params
    params.require(:organization).permit(:name, :currency)
  end
end
