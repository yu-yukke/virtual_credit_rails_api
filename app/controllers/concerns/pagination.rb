module Pagination
  extend ActiveSupport::Concern

  def pagination(resources)
    info = {
      has_previous: !resources.empty? && !resources.first_page?,
      has_next: !resources.empty? && !resources.last_page?,
      current_page: resources.current_page,
      total_pages: resources.total_pages,
      total_count: resources.total_count
    }

    info.transform_keys { |key| key.to_s.camelize(:lower) }
  end
end
