class QuoteItemsController < ApplicationController
  before_action :set_quote, only: %i[new create]
  before_action :set_quote_item, only: %i[edit update destroy]

  def new
    @quote_item = @quote.quote_items.build
  end

  def create
    @quote_item = @quote.quote_items.build(quote_item_params)

    if @quote_item.save
      redirect_to quote_url(@quote), notice: t('quote_items.messages.added')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quote_item.update(quote_item_params)
      redirect_to quote_url(@quote_item.quote), notice: t('quote_items.messages.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    quote = @quote_item.quote
    @quote_item.destroy
    redirect_to quote_url(quote), notice: t('quote_items.messages.removed')
  end

  private

  def set_quote
    @quote = Quote.find(params[:quote_id])
  end

  def set_quote_item
    @quote_item = QuoteItem.find(params[:id])
  end

  def quote_item_params
    params.require(:quote_item).permit(:product_id, :description, :quantity, :unit_price)
  end
end
