#include <iostream>
#include <string>

#include "util/print.hpp"

void print(std::string line) {
	std::cout << line << std::endl;
}

void print(int number) {
	std::cout << number << std::endl;
}
