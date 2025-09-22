class ClientsController < ApplicationController
  before_action :set_client, only: [ :show, :edit, :update, :destroy ]

  def index
    @clients = Current.organization ? Current.organization.clients : Client.none
  end

  def show
  end

  def new
    organization = Current.organization || create_default_organization
    @client = Client.new(organization: organization)
  end

  def edit
  end

  def create
    organization = Current.organization || create_default_organization
    @client = Client.new(client_params.merge(organization: organization))

    if @client.save
      redirect_to @client, notice: "Client was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Client was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_url, notice: "Client was successfully destroyed."
  end

  private

  def set_client
    @client = Current.organization.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :rtn, :address, :phone, :email)
  end

  def create_default_organization
    Organization.create!(name: "Default Organization", currency: "USD", language: "en")
  end
end
