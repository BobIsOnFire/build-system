#include "storage/storage.hpp"

#include "util/print.hpp"
#include "util/fancy_print.hpp"
#include "util/market.hpp"

void put(market &m, int value) {
	m.content.push_back(value);
}

void show(market &m) {
	print("Market size:");
	fancy_print(m.content.size());
	print("Market elements:");
	for (int el : m.content) print(el);
	print("");
}
