all : pcapDump

pcapDump : parse.o come_on_packet.o main.o
	g++ -g -std=c++14 -o pcapDump main.o come_on_packet.o parse.o -lpcap

parse.o : parse.h
	g++ -g -c -std=c++14 -o parse.o parse.cpp

come_on_packet.o : come_on_packet.h
	g++ -g -c -std=c++14 -o come_on_packet.o come_on_packet.cpp

main.o : main.cpp parse.h come_on_packet.h
	g++ -g -c -std=c++14 -o main.o main.cpp

clean:
	rm *.o pcapDump
