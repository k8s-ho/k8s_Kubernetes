#include "parse.h"

parse::parse(int argc, char *argv[]){
    check_argc(argc, argv);
}
void parse::check_argc(int argc, char *argv[]){
    if(argc!=2)
    {
        cout << "[!] Error: Please refer to the usage and enter the appropriate option :( \n";
        cout << "[?] Usage: ./packetDump [interface name] \n";
        exit(1);
    }
    this->interface=argv[1];
}
char *parse::using_interface(){
    return this->interface;
}
