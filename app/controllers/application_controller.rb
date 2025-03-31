class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  before_action :set_locale
  
  private
  
  def set_locale
    I18n.locale = if Current.user&.language.present?
                    Current.user.language.to_sym
                  elsif session[:locale].present?
                    session[:locale].to_sym
                  else
                    I18n.default_locale
                  end
  end
end
