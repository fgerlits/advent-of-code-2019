#include <algorithm>
#include <array>
#include <cmath>
#include <exception>
#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>

constexpr int MAX = 9999;

int sign(int number) {
    if (number > 0) return 1;
    else if (number == 0) return 0;
    else return -1;
}

class Step {
public:
    int right = 0;
    int down = 0;

    Step() = default;

    Step(char direction, int amount) {
        switch(direction) {
            case 'L' : right = - amount; break;
            case 'R' : right = amount; break;
            case 'U' : down = - amount; break;
            case 'D' : down = amount; break;
        }
    }

    int xDirection() {
        return sign(right);
    }

    int yDirection() {
        return sign(down);
    }

    int size() {
        return std::max(std::abs(right), std::abs(down));
    }
};

struct Coords{
    int x, y;
};

std::ostream& operator<<(std::ostream& stream, const Coords& coords) {
    stream << '(' << coords.x << ", " << coords.y << ')';
    return stream;
}

constexpr Coords ORIGIN{0, 0};

int manhattanDistance(Coords const& left, Coords const& right) {
    return std::abs(right.x - left.x) + std::abs(right.y - left.y);
}

bool closerToTheOrigin(Coords const& left, Coords const& right) {
    return manhattanDistance(ORIGIN, left) < manhattanDistance(ORIGIN, right);
}

class Distances {
private:
    static const int UNSET = -1;
    std::array<int, 2> distance;

public:
    Distances() : distance{UNSET, UNSET} {
    }

    void set(std::size_t which, int toWhat) {
        if (distance[which] == UNSET) {
            distance[which] = toWhat;
        }
    }

    int total() const {
        return distance[0] + distance[1];
    }

    int at(std::size_t which) const {
        return distance[which];
    }

    bool isIntersection() const {
        return distance[0] != UNSET && distance[1] != UNSET;
    }
};

std::ostream& operator<<(std::ostream& stream, Distances const& distances) {
    stream << '(' << distances.at(0) << ", " << distances.at(1) << ')';
    return stream;
}

class Board {
private:
    static const int SIZE = 2 * MAX + 1;
    std::vector<std::vector<Distances>> board{SIZE, std::vector<Distances>(SIZE)};

public:
    Distances& at(int i, int j) {
        if (std::abs(i) > MAX || std::abs(j) > MAX) {
            throw std::out_of_range("the board is not large enough");
        }
        return board[i + MAX][j + MAX];
    }

    void addSteps(std::vector<Step> steps, std::size_t wireNumber) {
        int x = 0;
        int y = 0;
        int wireDistance = 0;
        for (Step step : steps) {
            for (int d = 0; d < step.size(); ++d) {
                x += step.xDirection();
                y += step.yDirection();
                wireDistance += 1;
                at(x, y).set(wireNumber, wireDistance);
            }
        }
    }

    int findMinTotalDistance() {
        std::vector<int> found;
        for (int x = -MAX; x <= MAX; ++x) {
            for (int y = -MAX; y <= MAX; ++y) {
                if (at(x, y).isIntersection()) {
                    //std::cout << "found intersection at (" << x << ", " << y << ")"
                    //    << " with distances: " << at(x, y) << '\n';
                    found.push_back(at(x, y).total());
                }
            }
        }
        auto it = std::min_element(found.begin(), found.end());
        if (it != found.end()) {
            return *it;
        } else {
            throw std::runtime_error("no intersections found");
        }
    }
};

std::istream& operator>>(std::istream& stream, Step& step) {
    char direction;
    int amount;
    char separator;
    stream >> direction >> amount >> separator;
    step = Step(direction, amount);
    return stream;
}

std::ostream& operator<<(std::ostream& stream, const Step& step) {
    stream << '(' << step.right << ", " << step.down << ')';
    return stream;
}

std::vector<Step> readSteps() {
    std::string line;
    if (! std::getline(std::cin, line)) {
        throw std::out_of_range("could not read line");
    }
    std::istringstream stream{line + ','};
    std::istream_iterator<Step> begin{stream}, end;
    std::vector<Step> steps{begin, end};
    return steps;
}

void printSteps(std::vector<Step> const& steps) {
    std::copy(steps.begin(), steps.end(), std::ostream_iterator<Step>(std::cout, ", "));
    std::cout << '\n';
}

int main() {
    Board board;
    std::vector<Step> wire1, wire2;

    wire1 = readSteps();
    wire2 = readSteps();

//    printSteps(wire1);
//    printSteps(wire2);

    board.addSteps(wire1, 0);
    board.addSteps(wire2, 1);
    
    std::cout << "smallest total distance: " << board.findMinTotalDistance() << '\n';

    return 0;
}
