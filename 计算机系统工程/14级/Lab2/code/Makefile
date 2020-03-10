#
# To compile, type "make" or make "all"
# To remove files, type "make clean"
#
OBJS = server.o request.o cse.o client.o
TARGET = server

CC = gcc
CFLAGS = -g -Wall

.SUFFIXES: .c .o 

all: server client output.cgi

server: server.o request.o cse.o
	$(CC) $(CFLAGS) -o server server.o request.o cse.o

client: client.o cse.o
	$(CC) $(CFLAGS) -o client client.o cse.o

output.cgi: output.c
	$(CC) $(CFLAGS) -o output.cgi output.c

.c.o:
	$(CC) $(CFLAGS) -o $@ -c $<

clean:
	-rm -f $(OBJS) server client output.cgi
