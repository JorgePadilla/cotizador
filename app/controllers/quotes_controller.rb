class QuotesController < ApplicationController
  before_action :set_quote, only: %i[show edit update destroy pdf]

  def index
    @quotes = Quote.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @quote = Quote.new
    @quote.valid_until = 1.month.from_now.to_date
  end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: "Quote was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: "Quote was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy
    redirect_to quotes_url, notice: "Quote was successfully deleted."
  end

  def pdf
    respond_to do |format|
      format.pdf do
        pdf = QuotePdf.new(@quote)
        send_data pdf.render,
                  filename: "quote-#{@quote.quote_number}.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:client_id, :valid_until, :status)
  end
end
