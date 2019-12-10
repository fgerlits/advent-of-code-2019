#include "one.hpp"
#include <exception>
#include <iostream>
#include <iterator>

void deleteFrom(std::vector<Coords> & asteroids, Coords const& asteroid) {
    auto it = std::find(begin(asteroids), end(asteroids), asteroid);
    if (it != end(asteroids)) {
        asteroids.erase(it);
    } else {
        throw std::runtime_error("asteroid not found in the list");
    }
}

std::vector<int> computeDistances(Coords const& asteroid, std::vector<Coords> const& asteroids) {
    std::vector<int> distances;
    for (Coords const& otherAsteroid : asteroids) {
        distances.push_back((otherAsteroid - asteroid).absoluteManhattanLength());
    }
    return distances;
}

std::vector<double> computeAngles(std::vector<Direction> const& directions) {
    std::vector<double> angles;
    for (auto const& direction : directions) {
        angles.push_back(direction.angle());
    }
    return angles;
}

struct Visibility {
    Coords location;
    Direction direction;
    double angle;
    int distance;
};

std::ostream& operator<<(std::ostream& out, Visibility const& visibility) {
    out << visibility.location
        << " direction: " << visibility.direction
        << " angle: " << visibility.angle
        << " distance: " << visibility.distance;
    return out;
}

std::vector<Visibility> zip(std::vector<Coords> const& coords,
                            std::vector<Direction> const& directions,
                            std::vector<double> const& angles,
                            std::vector<int> const& distances) {
    std::vector<Visibility> visibilities;
    for (std::size_t i = 0; i < coords.size(); ++i) {
        visibilities.push_back(Visibility{coords[i], directions[i], angles[i], distances[i]});
    }
    return visibilities;
}

bool operator<(Visibility const& left, Visibility const& right) {
    if (left.angle < right.angle) return true;
    else if (left.angle > right.angle) return false;
    else return left.distance < right.distance;
}

constexpr Coords basis{23, 29};
constexpr double EPSILON = 1e-15;

int main() {
    std::istream_iterator<std::string> begin{std::cin}, end;
    Grid grid{std::vector<std::string>{begin, end}};

    std::vector<Coords> asteroids = grid.findAsteroids();
    deleteFrom(asteroids, basis);
    std::vector<Direction> directions = computeDirections(basis, asteroids);
    std::vector<double> angles = computeAngles(directions);
    std::vector<int> distances = computeDistances(basis, asteroids);
    std::vector<Visibility> visibilities = zip(asteroids, directions, angles, distances);
    std::sort(visibilities.begin(), visibilities.end());

    int counter = 1;
    while (! visibilities.empty()) {
        std::vector<Visibility> survivors;
        double lastAngle = -1;
        for (auto const& visibility : visibilities) {
            if (std::abs(visibility.angle - lastAngle) > EPSILON) {
                std::cout << counter++ << ": " << visibility << '\n';
                lastAngle = visibility.angle;
            } else {
                survivors.push_back(visibility);
            }
        }
        visibilities = survivors;
        std::cout << "### finished rotation ###\n";
    }

    return 0;
}
