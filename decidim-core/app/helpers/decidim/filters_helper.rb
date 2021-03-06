# frozen_string_literal: true

module Decidim
  # Helper that provides a single method to create filter resource forms
  module FiltersHelper
    # This method wraps everything in a div with class filters and calls
    # the form_for helper with a custom builder
    #
    # filter - A filter object
    # url    - A String with the URL to post the from. Self URL by default.
    # block  - A block to be called with the form builder
    #
    # Returns the filter resource form wrapped in a div
    def filter_form_for(filter, url = url_for)
      content_tag :div, class: "filters" do
        form_for filter, namespace: filter_form_namespace, builder: FilterFormBuilder, url: url, as: :filter, method: :get, remote: true, html: { id: nil } do |form|
          yield form
        end
      end
    end

    private

    # Creates a unique namespace for a filter form to prevent dupliacte IDs in
    # the DOM when multiple filter forms are rendered with the same fields (e.g.
    # for desktop and mobile).
    def filter_form_namespace
      "filters_#{SecureRandom.uuid}"
    end
  end
end
