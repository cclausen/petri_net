class PetriNet::ReachabilityGraph::Node < PetriNet::Base
    # human readable name
    attr_reader :name
    # unique ID
    attr_reader :id 
    # Makking this node represents
    attr_reader :markings
    # The graph this node belongs to
    attr_accessor :graph

    def initialize(options = {}, &block)
        @id = next_object_id
        @name = (options[:name] or "Node#{@id}")
        @description = (options[:description] or "Node #{@id}")
        @inputs = Array.new
        @outputs = Array.new
        @label = (options[:label] or @name)
        @markings = options[:markings] 

        yield self unless block.nil?
    end

    def validate
        true
    end

    def gv_id
        "N#{@id}"
    end

    def to_gv
        "\t#{self.gv_id} [ label = \"#{@markings}\" ];\n"
    end

    def ==(object)
        return false unless object.class.to_s == "PetriNet::ReachabilityGraph::Node"
        @markings == object.markings
    end

    def to_s
        "#{@id}: #{@name} (#{@markings})"
    end

end