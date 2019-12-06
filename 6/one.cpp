#include <iostream>
#include <string>

#include "directed_acyclic_graph.hpp"

int main() {
    std::vector<std::pair<std::string, std::string>> input;
    while (std::cin) {
        std::string line;
        std::cin >> line;
        if (line.size() >= 7) {
            input.emplace_back(line.substr(0, 3), line.substr(4, 3));
        }
    };
//    for (auto const& edge : input) {
//        std::cout << edge.first << ')' << edge.second << '\n';
//    }

    DirectedAcyclicGraph<std::string, int, void> graph{input, "COM"};
    std::cout << graph;

    return 0;
}
