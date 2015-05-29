module Mrkt
  module CrudLeads
    def get_leads(filter_type, filter_values, options = {})
      fields = options.fetch(:fields, nil)
      batch_size = options.fetch(:batch_size, nil)
      next_page_token = options.fetch(:next_page_token, nil)

      params = {
        :filterType => filter_type,
        :filterValues => filter_values.join(',')
      }
      params[:fields] = fields if fields
      params[:batchSize] = batch_size if batch_size
      params[:nextPageToken] = next_page_token if next_page_token

      get('/rest/v1/leads.json', params)
    end

    def createupdate_leads(leads, options = {})
      action = options.fetch(:action, 'createOrUpdate')
      lookup_field = options.fetch(:lookup_field, nil)
      partition_name = options.fetch(:partition_name, nil) 
      async_processing = options.fetch(:async_processing, nil)

      post('/rest/v1/leads.json') do |req|
        params = {
          :action => action,
          :input => leads
        }
        params[:lookupField] = lookup_field if lookup_field
        params[:partitionName] = partition_name if partition_name
        params[:asyncProcessing] = async_processing if async_processing

        json_payload(req, params)
      end
    end

    def delete_leads(leads)
      delete('/rest/v1/leads.json') do |req|
        json_payload(req, :input => leads.map { |lead_id| { :id => lead_id } })
      end
    end

    def json_payload(req, payload)
      req.headers[:content_type] = 'application/json'
      req.body = JSON.generate(payload)
    end

    def associate_lead(id, cookie)
      params = Faraday::Utils::ParamsHash.new
      params[:cookie] = cookie

      post("/rest/v1/leads/#{id}/associate.json?#{params.to_query}") do |req|
        json_payload(req, {})
      end
    end
  end
end
