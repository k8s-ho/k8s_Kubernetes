#include <iostream>
#include <string.h>
#include <unistd.h>
#include "parse.h"
#include "come_on_packet.h"

#define PROMISCUOUS 1
#define NONPROMISCUOUS 0

using namespace std;

int main(int argc, char *argv[])
{
    parse ps(argc,argv);
    come_on_packet(&ps);
    return 0;
}
