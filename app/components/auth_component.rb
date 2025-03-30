# frozen_string_literal: true

class AuthComponent < ApplicationComponent
  renders_one :title
  renders_one :main_content
  renders_one :footer

  def initialize(title_text: nil)
    @title_text = title_text
  end
end
