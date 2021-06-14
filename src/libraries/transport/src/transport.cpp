#include "transport/transport.hpp"

#include "util/market.hpp"

int inc(market &m, int index) {
	return ++m.content[index];
}

int dec(market &m, int index) {
	return --m.content[index];
}
