class ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Current.organization ? Current.organization.products.order(created_at: :desc) : Product.none
  end

  def show
  end

  def new
    @product = Product.new(organization: Current.organization)
  end

  def edit
  end

  def create
    @product = Product.new(product_params.merge(organization: Current.organization))

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: "Product was successfully deleted."
  end

  private

  def set_product
    @product = Current.organization.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :sku, :price, :stock, :supplier_id)
  end
end
