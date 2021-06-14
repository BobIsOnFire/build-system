#include "storage/storage.hpp"
#include "util/market.hpp"

int main() {
	market m = init();
	put(m, 3);
	put(m, 10000);
	put(m, 0);
	put(m, 80);
	put(m, 31);
	put(m, 92);

	show(m);
}
