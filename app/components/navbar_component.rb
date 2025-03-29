class NavbarComponent < ViewComponent::Base
  def initialize(current_path:)
    @current_path = current_path
  end

  private

  def active_class(path)
    @current_path.start_with?(path) ? "bg-gray-900 text-white" : "text-gray-300 hover:bg-gray-700 hover:text-white"
  end
end
