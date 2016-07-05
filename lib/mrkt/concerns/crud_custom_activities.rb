require 'time'

module Mrkt
  module CrudCustomActivities
    def get_list_of_custom_activity_types()
      get('/rest/v1/activities/types.json')
    end

    def create_custom_activity(lead_id, activity_type_id, primary_attribute_value, attributes: {}, date: nil)
      date ||= Time.now()
      date = date.utc.iso8601
      converted_attributes = convert_attribute_hash(attributes)

      input = [{
        leadId: lead_id,
        activityDate: date,
        activityTypeId: activity_type_id,
        primaryAttributeValue: primary_attribute_value,
        attributes: converted_attributes
      }]
      post("/rest/v1/activities/external.json") do |req|
        params = {
          input: input
        }
        json_payload(req, params)
      end
    end

    private

    def convert_attribute_hash(attributes)
      converted_attributes = []
      attributes.each do |key, value|
        converted_attributes << {name: key, value: value}
      end
      return converted_attributes
    end
  end
end
