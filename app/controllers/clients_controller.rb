class ClientsController < ApplicationController
  before_action :set_client, only: [ :show, :edit, :update, :destroy ]

  def index
    @clients = Current.organization ? Current.organization.clients : Client.none
  end

  def show
  end

  def new
    @client = Client.new(organization: Current.organization)
  end

  def edit
  end

  def create
    @client = Client.new(client_params.merge(organization: Current.organization))

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
end
