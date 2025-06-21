module ApplicationHelper
  def nav_link_classes(active = false)
    base_classes = "text-gray-300 hover:text-indigo-400 px-3 py-2 rounded-md text-sm font-medium transition-colors duration-200"
    active ? "#{base_classes} text-indigo-400 bg-gray-700" : base_classes
  end

  def mobile_nav_link_classes(active = false)
    base_classes = "text-gray-300 hover:text-indigo-400 block px-3 py-2 rounded-md text-base font-medium transition-colors duration-200"
    active ? "#{base_classes} text-indigo-400 bg-gray-700" : base_classes
  end

  def button_classes(style = :primary, size = :medium)
    base_classes = "inline-flex items-center justify-center rounded-md font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-900"

    style_classes = case style
    when :primary
      "bg-indigo-600 text-white hover:bg-indigo-700 focus:ring-indigo-500"
    when :secondary
      "bg-gray-700 text-white hover:bg-gray-600 focus:ring-gray-500"
    when :outline
      "border border-gray-600 bg-gray-800 text-gray-300 hover:bg-gray-700 focus:ring-indigo-500"
    when :danger
      "bg-red-600 text-white hover:bg-red-700 focus:ring-red-500"
    end

    size_classes = case size
    when :small
      "px-3 py-1.5 text-sm"
    when :medium
      "px-4 py-2 text-sm"
    when :large
      "px-6 py-3 text-base"
    end

    "#{base_classes} #{style_classes} #{size_classes}"
  end

  def card_classes
    "bg-gray-800 rounded-lg shadow-sm border border-gray-700 p-6"
  end

  def input_classes
    "block w-full rounded-md border-gray-600 bg-gray-700 text-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm px-3 py-2 placeholder-gray-400"
  end

  def label_classes
    "block text-sm font-medium text-gray-300 mb-1"
  end

  def select_classes
    "block w-full rounded-md border-gray-600 bg-gray-700 text-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm px-3 py-2"
  end

  def textarea_classes
    "block w-full rounded-md border-gray-600 bg-gray-700 text-gray-100 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm px-3 py-2 placeholder-gray-400 resize-y"
  end
end
