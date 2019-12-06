#include <iostream>
#include <string>

#include "directed_acyclic_graph.hpp"

struct DepthCalculator {
    void operator()(Node<std::string, int> & node) {
        int depth = node.getParent()->getValue() + 1;
        node.setValue(depth);
    }
};

struct DepthSummer {
    int total = 0;
    void operator()(Node<std::string, int> & node) {
        total += node.getValue();
    }
};

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
    DepthCalculator calculator;
    graph.breadthFirstWalk(calculator);
    DepthSummer summer;
    graph.breadthFirstWalk(summer);
    std::cout << summer.total << '\n';

    return 0;
}
