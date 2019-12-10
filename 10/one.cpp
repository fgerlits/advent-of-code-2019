#include "one.hpp"
#include <iostream>
#include <iterator>

int main() {
    std::istream_iterator<std::string> begin{std::cin}, end;
    Grid grid{std::vector<std::string>{begin, end}};

    std::vector<Coords> asteroids = grid.findAsteroids();
    int maxVisible = 0;
    for (Coords const& asteroid : asteroids) {
        std::vector<Direction> directions = computeDirections(asteroid, asteroids);
        int visible = countUnique(directions);
        if (visible > maxVisible) {
            std::cout << asteroid << " can see " << visible << " others\n";
            maxVisible = visible;
        }
    }

    return 0;
}
