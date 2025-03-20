# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  attr_reader :text, :type, :classes

  def initialize(text:, type: :primary, classes: nil)
    @text = text
    @type = type
    @classes = classes
  end

  def button_classes
    base_classes = "font-bold py-2 px-4 rounded transition duration-300 ease-in-out"

    type_classes = case type
    when :primary
                    "bg-blue-500 hover:bg-blue-700 text-white"
    when :secondary
                    "bg-gray-300 hover:bg-gray-400 text-gray-800"
    when :success
                    "bg-green-500 hover:bg-green-700 text-white"
    when :danger
                    "bg-red-500 hover:bg-red-700 text-white"
    else
                    "bg-blue-500 hover:bg-blue-700 text-white"
    end

    [ base_classes, type_classes, classes ].compact.join(" ")
  end
end
