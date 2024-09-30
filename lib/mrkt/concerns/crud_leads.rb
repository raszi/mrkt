module Mrkt
  module CrudLeads
    def get_lead_by_id(id, fields: nil)
      optional = {
        fields: fields
      }

      get("/rest/v1/lead/#{id}.json", {}, optional)
    end

    def get_leads(filter_type, filter_values, fields: nil, batch_size: nil, next_page_token: nil)
      params = {
        filterType: filter_type,
        filterValues: filter_values
      }

      optional = {
        fields: fields,
        batchSize: batch_size,
        nextPageToken: next_page_token
      }

      get('/rest/v1/leads.json', params, optional)
    end

    def createupdate_leads(leads, action: 'createOrUpdate', lookup_field: nil, partition_name: nil, async_processing: nil,
                           program_name: nil)
      post_json('/rest/v1/leads.json') do
        params = {
          action: action,
          input: leads
        }

        optional = {
          lookupField: lookup_field,
          partitionName: partition_name,
          asyncProcessing: async_processing,
          programName: program_name # listed as optional so as to not break existing consumers of the gem.
        }

        merge_params(params, optional)
      end
    end

    def delete_leads(leads)
      delete('/rest/v1/leads.json') do |req|
        json_payload(req, input: map_lead_ids(leads))
      end
    end

    def associate_lead(id, cookie)
      params = Mrkt::Faraday::ParamsEncoder.encode(cookie: cookie)

      post_json("/rest/v1/leads/#{id}/associate.json?#{params}")
    end

    def merge_leads(winning_lead_id, losing_lead_ids, merge_in_crm: false)
      params = {}

      params[:mergeInCRM] = merge_in_crm
      params[:leadIds] = losing_lead_ids if losing_lead_ids

      query_params = Mrkt::Faraday::ParamsEncoder.encode(params)

      post_json("/rest/v1/leads/#{winning_lead_id}/merge.json?#{query_params}")
    end

    def describe_lead
      get('/rest/v1/leads/describe.json')
    end
  end
end
