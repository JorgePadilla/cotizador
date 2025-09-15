require_relative "../pdfs/quote_pdf"

class QuotesController < ApplicationController
  before_action :set_quote, only: %i[show edit update destroy pdf]

  def index
    @current_page = params[:page].to_i > 0 ? params[:page].to_i : 1
    offset_value = (@current_page - 1) * 10
    @quotes = Current.organization ? Current.organization.quotes.order(created_at: :desc).limit(10).offset(offset_value) : Quote.none
    @total_quotes = Current.organization ? Current.organization.quotes.count : 0
    @total_pages = (@total_quotes.to_f / 10).ceil
  end

  def show
  end

  def new
    @quote = Quote.new(organization: Current.organization)
    @quote.valid_until = 1.month.from_now.to_date
  end

  def create
    @quote = Quote.new(quote_params.merge(organization: Current.organization))

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
    @quote = Current.organization.quotes.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(:client_id, :valid_until, :status)
  end
end
