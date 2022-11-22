#include "parse.h"

parse::parse(int argc, char *argv[]){
    check_argc(argc, argv);
}
void parse::check_argc(int argc, char *argv[]){
    if(argc!=2)
    {
        cout << "***** 인자값이 잘못되었거나 존재하지 않습니다 *****\n";
        cout << "    >> 사용법 : <dev>\n";
        exit(1);
    }
    this->interface=argv[1];
}
char *parse::using_interface(){
    return this->interface;
}
