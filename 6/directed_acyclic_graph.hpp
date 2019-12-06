#pragma once

#include <exception>
#include <ostream>
#include <queue>
#include <utility>
#include <unordered_map>
#include <vector>

template<typename NodeName, typename Payload>
class Node {
private:
    NodeName const name;
    Node const* const parent;
    std::vector<Node *> children;
    Payload value;

public:
    Node(NodeName const& name_, Node const* parent_)
        : name(name_), parent(parent_) {
    }

    NodeName getName() const { return name; }
    Node const* getParent() const { return parent; }
    Payload getValue() const { return value; }
    void setValue(Payload const& value_) { value_ = value; }

    std::vector<Node *> const& getChildren() const { return children; }
    Node * addChild(NodeName childName) {
        Node * child = new Node{childName, this};
        children.push_back(child);
        return child;
    }
};

template<typename NodeName, typename Payload, typename Callback>
class DirectedAcyclicGraph {
private:
    using NodeType = Node<NodeName, Payload>;

    Node<NodeName, Payload> rootNode;
    std::unordered_map<NodeName, NodeType *> nodeLookupTable;

public:
    DirectedAcyclicGraph(std::vector<std::pair<NodeName, NodeName>> edges, NodeName const& rootName)
        : rootNode{rootName, nullptr} {
        nodeLookupTable[rootName] = &rootNode;

        std::unordered_multimap<NodeName, NodeName> edgeMap;
        for (auto const& edge : edges) {
            edgeMap.emplace(edge.first, edge.second);
        }

        std::queue<NodeName> todoList;
        todoList.push(rootName);
        while (! todoList.empty()) {
            NodeName parentName = todoList.front();
            todoList.pop();
            auto [begin, end] = edgeMap.equal_range(parentName);
            for (auto it = begin; it != end; ++it) {
                NodeName childName = it->second;
                addChild(parentName, childName);
                todoList.push(childName);
            }
        }
    }

    void addChild(NodeName const& parentName, NodeName const& childName) {
        if (nodeLookupTable.count(parentName) == 0) {
            throw new std::logic_error{"parent not found"};
        }
        if (nodeLookupTable.count(childName) != 0) {
            throw new std::logic_error{"child already exists"};
        }
        NodeType * parent = nodeLookupTable.at(parentName);
        Node<NodeName, Payload> * child = parent->addChild(childName);
        nodeLookupTable[childName] = child;
    }

    NodeType const& getRootNode() const { return rootNode; }
};

template<typename N, typename P, typename C>
std::ostream & operator<<(std::ostream & out, DirectedAcyclicGraph<N, P, C> const& graph) {
    using NodeType = Node<N, P>;
    std::queue<NodeType const*> todoList;
    todoList.push(&graph.getRootNode());
    while (! todoList.empty()) {
        NodeType const* node = todoList.front();
        todoList.pop();
        for (NodeType const* child : node->getChildren()) {
            out << node->getName() << ')' << child->getName() << '\n';
            todoList.push(child);
        }
    }
    return out;
}
