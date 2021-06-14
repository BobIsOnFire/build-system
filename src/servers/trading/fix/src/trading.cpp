#include "transport/transport.hpp"
#include "storage/storage.hpp"
#include "util/market.hpp"

int main() {
	market m = init();
	show(m);

	put(m, 0);
	inc(m, 0);
	inc(m, 0);
	inc(m, 0);
	show(m);

	put(m, 10);
	inc(m, 1);
	inc(m, 1);
	dec(m, 0);
	inc(m, 1);
	show(m);

	put(m, 2);
	dec(m, 2);
	dec(m, 2);
	dec(m, 0);
	dec(m, 1);
	dec(m, 1);
	show(m);
}
