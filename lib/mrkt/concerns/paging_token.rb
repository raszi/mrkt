module Mrkt
  module PagingToken
    def get_paging_token(date)
      params = { sinceDatetime: format_date(date) }

      get("/rest/v1/activities/pagingtoken.json", params)[:nextPageToken]
    end

    private

    def format_date(date)
      date = Date.parse(date) if date.is_a? String

      unless date.is_a? Date
        fail ArgumentError.new("Expected Date or String. Got #{date.class}")
      end

      date.strftime("%FT%T")
    end
  end
end
