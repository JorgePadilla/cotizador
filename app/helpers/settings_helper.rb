module SettingsHelper
  ICON_PATHS = {
    "user" => "M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z",
    "sliders" => "M4 6h16M4 10h10M4 14h16M4 18h10",
    "building" => "M3 21V7a2 2 0 012-2h6a2 2 0 012 2v14m4 0V11a2 2 0 012-2h2a2 2 0 012 2v10M3 21h18M9 9h2m-2 4h2m-2 4h2",
    "users" => "M17 20h5v-2a4 4 0 00-3-3.87M9 20H4v-2a4 4 0 013-3.87m3-5.13a4 4 0 110-8 4 4 0 010 8zm6 0a3 3 0 110-6 3 3 0 010 6z",
    "shield-check" => "M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z",
    "chevron-right" => "M9 5l7 7-7 7",
    "plus" => "M12 4v16m8-8H4",
    "chart" => "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z",
    "logout" => "M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
  }.freeze

  def sidebar_icon(name)
    path = ICON_PATHS[name] || ICON_PATHS["chevron-right"]
    content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "h-4 w-4 shrink-0", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
      content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: path)
    end
  end

  def settings_card_icon(name, color: "blue")
    path = ICON_PATHS[name] || ICON_PATHS["chevron-right"]
    text_class = color == "red" ? "text-red-600" : "text-blue-600"
    content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", class: "h-6 w-6 #{text_class}", fill: "none", viewBox: "0 0 24 24", stroke: "currentColor") do
      content_tag(:path, "", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: path)
    end
  end

  def settings_card(title, subtitle: nil, &block)
    content_tag(:section, class: "bg-white shadow-sm rounded-lg p-6 mb-6") do
      header = content_tag(:header, class: "mb-4") do
        title_html = content_tag(:h3, title, class: "text-base font-semibold text-gray-900")
        title_html += content_tag(:p, subtitle, class: "text-sm text-gray-500 mt-1") if subtitle.present?
        title_html
      end
      header + content_tag(:div, capture(&block))
    end
  end
end
