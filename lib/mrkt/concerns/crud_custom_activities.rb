require 'time'

module Mrkt
  module CrudCustomActivities
    def get_list_of_custom_activity_types
      warn 'DEPRECATED: Use #get_activity_types instead of #get_list_of_custom_activity_types!'
      get_activity_types
    end

    def create_custom_activity(lead_id, activity_type_id, primary_attribute_value, attributes: {}, date: nil)
      date ||= Time.now
      date = date.utc.iso8601
      converted_attributes = convert_attribute_hash(attributes)

      input = [{
        leadId: lead_id,
        activityDate: date,
        activityTypeId: activity_type_id,
        primaryAttributeValue: primary_attribute_value,
        attributes: converted_attributes
      }]
      post('/rest/v1/activities/external.json') do |req|
        json_payload(req, input: input)
      end
    end

    private

    def convert_attribute_hash(attributes)
      attributes.map do |key, value|
        { name: key, value: value }
      end
    end
  end
end
