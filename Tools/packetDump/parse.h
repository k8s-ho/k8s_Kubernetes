#ifndef PARSE_H
#define PARSE_H
#include <iostream>

using namespace std;


class parse{
private:
    char *interface;
public:
    parse(int argc, char *argv[]);
    void check_argc(int argc, char *argv[]);
    char *using_interface();
};

#endif // PARSE_H
