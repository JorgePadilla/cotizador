# Configure ViewComponent
Rails.application.config.view_component.preview_paths << "#{Rails.root}/spec/components/previews"
Rails.application.config.view_component.preview_controller = "ComponentPreviewController"
