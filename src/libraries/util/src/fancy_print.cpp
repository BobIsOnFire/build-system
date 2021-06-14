#include <string>

#include "util/fancy_print.hpp"
#include "util/print.hpp"

void fancy_print(std::string line) {
	print("**** " + line + " ****");
}

void fancy_print(int number) {
	print("@@@@ " + std::to_string(number) + " @@@@");
}
