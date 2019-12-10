#include "one.hpp"
#include <algorithm>
#include <iostream>
#include <iterator>

constexpr char ASTEROID = '#';

std::vector<Coords> findAsteroids(Grid const& grid) {
    std::vector<Coords> asteroids;
    for (int y = 0; y < grid.ysize; ++y) {
        for (int x = 0; x < grid.xsize; ++x) {
            if (grid.at(x, y) == ASTEROID) {
                asteroids.push_back(Coords{x, y});
            }
        }
    }
    return asteroids;
}

std::vector<Direction> computeDirections(Coords const& asteroid, std::vector<Coords> asteroids) {
    std::vector<Direction> directions;
    for (Coords const& otherAsteroid : asteroids) {
        if (otherAsteroid != asteroid) {
            directions.push_back(simplify(direction(asteroid, otherAsteroid)));
        }
    }
    return directions;
}

int countUnique(std::vector<Direction> directions) {
    std::sort(begin(directions), end(directions));
    auto last = std::unique(begin(directions), end(directions));
    return std::distance(begin(directions), last);
}

int main() {
    std::istream_iterator<std::string> begin{std::cin}, end;
    Grid grid{std::vector<std::string>{begin, end}};

    std::vector<Coords> asteroids = findAsteroids(grid);
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
