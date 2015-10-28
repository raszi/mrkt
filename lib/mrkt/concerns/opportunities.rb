module Mrkt
  module Opportunities
    def get_opportunities(filter_type, filter_values, fields: nil, batch_size: nil, next_page_token: nil)
      params = {
        filterType: filter_type,
        filterValues: filter_values.join(',')
      }
      params[:fields] = fields if fields
      params[:batchSize] = batch_size if batch_size
      params[:nextPageToken] = next_page_token if next_page_token

      get('/rest/v1/opportunities.json', params)
    end

    def describe_opportunity
      get('/rest/v1/opportunities/describe.json')
    end
  end
end
