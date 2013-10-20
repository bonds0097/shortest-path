################################################################################
# Author: Alfredo Ramirez
# Program: Shortest Path
# Description: This program calculates the shortest path from the first node to
# last node on a connected, undirected graph.
# Date: 10/20/2013
################################################################################

# This class is a graph node that can be used for a BFS tree. Each node has a
# name and predecessor as well as a flag that indicates whether it has been
# discovered.
class Node
    attr_reader :name
    attr_accessor :predecessor, :discovered

    def initialize(name)
        @name = name
        @predecessor = nil
        @discovered = false
    end

    def to_str
        name
    end

    def to_ary
        [name, predecessor, discovered]
    end
end

# This method generates an adjacency list from a string where the string is a
# comma-separated list. The first item is the number of nodes (N), followed by
# N nodes and then some number of edges.
def makeAdjList(graph)
    # Create a hash table to serve as adjList.
    adjList = Hash.new

    # Turn line into an array.
    graph = graph.tr("\"", "").strip.split(",")

    # Get the number of nodes.
    numNodes = graph[0].to_i

    # Initialize the adjList by adding each node with a blank list.
    graph[1, numNodes].each do |node|
        adjList.store(node, Array.new)
    end

    # Add each edge to the adjacency graph. Remember, I'm assuming this is an
    # undirected graph (since the instructions don't specif.)
    graph[numNodes + 1..-1].each do |edgeString|
        edge = edgeString.split("-")
        adjList[edge[0]].push(edge[1])
        adjList[edge[1]].push(edge[0])
    end

    return adjList
end

# This method returns the shortest path between the first and last node of an
# adjacency list. It uses a Breadth-First-Search in order to find this path.
def shortestPath(adjList)
    bfsTree = Hash.new          # Hashlist to hold your BFS tree.
    queue = Array.new           # Array to hold BFS queue.
    first = adjList.keys.first  # First node
    last = adjList.keys.last    # Last node
    path = Array.new            # Path to return

    # Initialize the BFS Tree
    adjList.keys.each do |node|
        bfsTree.store(node, Node.new(node))
    end

    # Run the BFS algorithm.
    # Start with the first node.
    current = first
    bfsTree[first].discovered = true

    # Loop through each node in the graph until you hit the last one.
    until current == last
        adjList[current].each do |node|
            unless bfsTree[node].discovered
                bfsTree[node].discovered = true
                bfsTree[node].predecessor = current
                queue.push(node)
            end
        end
        current = queue.shift
    end

    # Build shortest path.
    # Start with last node.
    current = last
    path.unshift(current)

    # Follow the predecessor chain until you reach the first node.
    until current == first
        current = bfsTree[current].predecessor
        path.unshift(current)
    end

    return path.join("-")
end

# Read in the graphs file as an array of lines.
graphs = File.new("graphs.in").readlines

# Find the shortest path between the first and last node in each graph.
for graph in graphs
    # Turn each line into an adjacency list.
    adjList = makeAdjList(graph)

    # Calculate the shortest path between the first node and the last node.
    puts shortestPath(adjList)
end


