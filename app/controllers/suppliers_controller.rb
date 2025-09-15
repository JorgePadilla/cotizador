class SuppliersController < ApplicationController
  before_action :set_supplier, only: [ :show, :edit, :update, :destroy ]

  def index
    @suppliers = Current.organization ? Current.organization.suppliers.order(created_at: :desc) : Supplier.none
  end

  def show
  end

  def new
    @supplier = Supplier.new(organization: Current.organization)
  end

  def edit
  end

  def create
    @supplier = Supplier.new(supplier_params.merge(organization: Current.organization))

    if @supplier.save
      redirect_to @supplier, notice: "Supplier was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @supplier.update(supplier_params)
      redirect_to @supplier, notice: "Supplier was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @supplier.destroy
    redirect_to suppliers_url, notice: "Supplier was successfully deleted."
  end

  private

  def set_supplier
    @supplier = Current.organization.suppliers.find(params[:id])
  end

  def supplier_params
    params.require(:supplier).permit(:name, :rtn, :address, :phone, :email, :contact_name)
  end
end
