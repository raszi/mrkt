module MktoRest
  class Lead
    attr_reader :vars
    def initialize(args)
      @vars = []
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
  end


end
