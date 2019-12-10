#pragma once

#include <numeric>
#include <ostream>
#include <string>
#include <vector>

struct Coords {
    int x, y;
};

bool operator==(Coords const& left, Coords const& right) {
    return left.x == right.x && left.y == right.y;
}

bool operator!=(Coords const& left, Coords const& right) {
    return !(left == right);
}

std::ostream& operator<<(std::ostream& out, Coords const& coords) {
    return out << '(' << coords.x << ", " << coords.y << ')';
}

struct Direction {
    int x, y;
};

bool operator<(Direction const& left, Direction const& right) {
    if (left.x < right.x) return true;
    else if (left.x == right.x && left.y < right.y) return true;
    else return false;
}

bool operator==(Direction const& left, Direction const& right) {
    return left.x == right.x && left.y == right.y;
}

Direction operator-(Coords const& to, Coords const& from) {
    return Direction{to.x - from.x, to.y - from.y};
}

Direction operator/(Direction const& direction, int divisor) {
    return Direction{direction.x / divisor, direction.y / divisor};
}

Direction simplify(Direction const& direction) {
    return direction / std::gcd(direction.x, direction.y);
}

Direction direction(Coords const& from, Coords const& to) {
    return simplify(to - from);
}

struct Grid {
    std::vector<std::string> grid;
    int xsize, ysize;

    Grid(std::vector<std::string> input)
        : grid{input}, xsize{int(input.at(0).size())}, ysize{int(input.size())} {
    }

    char at(std::size_t x, std::size_t y) const {
        return grid.at(y).at(x);
    }
};
