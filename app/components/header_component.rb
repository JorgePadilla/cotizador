# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  attr_reader :title, :subtitle

  def initialize(title:, subtitle: nil)
    @title = title
    @subtitle = subtitle
  end
end
