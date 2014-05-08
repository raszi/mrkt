module MktoRest
  class Lead
    attr_reader :vars, :client
    def initialize(client, args)
      @vars = []
      @client = client
      args.each do |k,v|
        @vars << k
        self.instance_variable_set("@#{k}", v)
      end
    end

    def method_missing(mthsym, *args)
      if @vars.include? mthsym
        return self.instance_variable_get("@#{mthsym}") if args.empty?
        self.instance_variable_set("@#{mthsym}", args[0])
      end
    end

    def update(args, attr = :id)
      if attr == :id 
        @client.update_lead_by_id self.id, args
      elsif attr == :email
        @client.update_lead_by_email self.email, args
      end
    end

    def to_s
      #@vars.collect { |k| "#{k} => #{self.send(k)}" }.join(", ")
      @vars.to_s
    end
  end


end
