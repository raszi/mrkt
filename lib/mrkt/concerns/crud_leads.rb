module Mrkt
  module CrudLeads
    def get_leads(filter_type, filter_values, fields: nil, batch_size: nil, next_page_token: nil)
      params = {
        filterType: filter_type,
        filterValues: filter_values.join(',')
      }
      params[:fields] = fields if fields
      params[:batchSize] = batch_size if batch_size
      params[:nextPageToken] = next_page_token if next_page_token

      get('/rest/v1/leads.json', params)
    end

    def createupdate_leads(leads, action: 'createOrUpdate', lookup_field: nil, partition_name: nil, async_processing: nil)
      post_json('/rest/v1/leads.json') do
        params = {
          action: action,
          input: leads
        }
        params[:lookupField] = lookup_field if lookup_field
        params[:partitionName] = partition_name if partition_name
        params[:asyncProcessing] = async_processing if async_processing

        params
      end
    end

    def delete_leads(leads)
      delete('/rest/v1/leads.json') do |req|
        json_payload(req, input: map_lead_ids(leads))
      end
    end

    def associate_lead(id, cookie)
      params = Faraday::Utils::ParamsHash.new
      params[:cookie] = cookie

      post_json("/rest/v1/leads/#{id}/associate.json?#{params.to_query}")
    end

    def merge_leads(winning_lead_id, losing_lead_ids, merge_in_crm: false)
      params = Faraday::Utils::ParamsHash.new
      params[:mergeInCRM] = merge_in_crm
      params[:leadIds] = losing_lead_ids.join(',') if losing_lead_ids

      post_json("/rest/v1/leads/#{winning_lead_id}/merge.json?#{params.to_query}")
    end
  end
end
