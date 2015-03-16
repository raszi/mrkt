module MktoRest
  class Lead
    attr_reader :vars, :client
    def initialize(client, args)
      @vars = []
      @client = client
      args.each do |k, v|
        @vars << k
        instance_variable_set("@#{k}", v)
      end
    end

    def method_missing(mthsym, *args)
      return unless @vars.include?(mthsym)
      return instance_variable_get("@#{mthsym}") if args.empty?
      instance_variable_set("@#{mthsym}", args[0])
    end

    def update(args, attr = :id)
      case attr
      when :id
        @client.update_lead_by_id(id, args)
      when :email
        @client.update_lead_by_email(email, args)
      end
    end

    def to_s
      @vars.map { |k| "#{k} => #{send(k)}" }.join(', ')
    end
  end
end
