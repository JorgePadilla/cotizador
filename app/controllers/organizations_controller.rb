class OrganizationsController < ApplicationController
  before_action :set_organization, only: [ :show, :edit, :update, :destroy, :switch ]
  before_action :require_organization_owner, only: [ :edit, :update, :destroy ]

  def index
    @organizations = Current.user.organizations
  end

  def show
    require_organization_member(@organization)
    @organization_users = @organization.organization_users.includes(:user).order(role: :desc, created_at: :asc)
  end

  def new
    @organization = Organization.new
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      @organization.organization_users.create(user: Current.user, role: "owner")
      Current.user.update(current_organization: @organization)
      redirect_to organizations_path, notice: "Organization was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to organizations_path, notice: "Organization was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: "Organization was successfully destroyed."
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name, :address, :phone, :email, :tax_id, :currency, :language)
  end
end
