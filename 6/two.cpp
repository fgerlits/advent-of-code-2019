#include <iostream>
#include <string>

#include "directed_acyclic_graph.hpp"

void computeDistances(DirectedAcyclicGraph<std::string, int> graph, std::string const& nodeName) {
    Node<std::string, int> * node = graph.getNodeByName(nodeName);
    int distance = -1;
    while (node) {
        if (node->getValue() != 0) {
            std::cout << node->getValue() + distance << '\n';
            std::exit(0);
        } else {
            node->setValue(distance);
            ++distance;
            node = node->getParent();
        }
    }
}

int main() {
    std::vector<std::pair<std::string, std::string>> input;
    while (std::cin) {
        std::string line;
        std::cin >> line;
        if (line.size() >= 7) {
            input.emplace_back(line.substr(0, 3), line.substr(4, 3));
        }
    };

    DirectedAcyclicGraph<std::string, int> graph{input, "COM"};
    computeDistances(graph, "YOU");
    computeDistances(graph, "SAN");

    std::cout << "we should never get here\n";
    return 1;
}
