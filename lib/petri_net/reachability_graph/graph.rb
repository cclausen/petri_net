class PetriNet::ReachabilityGraph < PetriNet::Base
    def initialize(net)
        @objects = Array.new
        @nodes = Hash.new
        @edges = Hash.new
        @name = net.name
    end

    def add_node(node)
        node_index = @objects.index node
        if (!node_index.nil?)
            return @objects[node_index].id * -1
        end

        if (node.validate && (!@nodes.include? node.name))
            @objects[node.id] = node
            @nodes[node.name] = node.id
            node.graph = self
            return node.id
        end
        return false
    end

    def add_edge(edge)
        if (edge.validate && (!@edges.include? edge.name))
            @objects[edge.id] = edge
            @edges[edge.name] = edge.id
            edge.graph = self
            return edge.id
        end
        return false
    end

    # Add an object to the Petri Net.
    def <<(object)
        case object.class.to_s
        when "Array"
            object.each {|o| self << o}
        when "PetriNet::ReachabilityGraph::Edge"
            add_edge(object)
        when "PetriNet::ReachabilityGraph::Node"
            add_node(object)
        else
            raise "(PetriNet::ReachabilityGraph) Unknown object #{object.class}."
        end
        self
    end
    alias_method :add_object, :<<

    def to_gv
        # General graph options
        str = "digraph #{@name} {\n"
        str += "\t// General graph options\n"
        str += "\trankdir = LR;\n"
        str += "\tsize = \"10.5,7.5\";\n"
        str += "\tnode [ style = filled, fillcolor = white, fontsize = 8.0 ]\n"
        str += "\tedge [ arrowhead = vee, arrowsize = 0.5, fontsize = 8.0 ]\n"
        str += "\n"

        str += "\t// Nodes\n"
        str += "\tnode [ shape = circle ];\n"
        @nodes.each_value {|id| str += @objects[id].to_gv }
        str += "\n"

        str += "\t// Edges\n"
        @edges.each_value {|id| str += @objects[id].to_gv }
        str += "}\n"    # Graph closure

        return str

    end

    def to_s
        str = "Reachability Graph [#{@name}]\n"
        str += "----------------------------\n"
        str += "Description: #{@description}\n"
        str += "Filename: #{@filename}\n"
        str += "\n"

        str += "Nodes\n"
        str += "----------------------------\n"
        @nodes.each_value {|p| str += @objects[p].to_s + "\n" }
        str += "\n"

        str += "Edges\n"
        str += "----------------------------\n"
        @edges.each_value {|t| str += @objects[t].to_s + "\n" }
        str += "\n"

        return str
    end

end