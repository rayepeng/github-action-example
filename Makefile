CC = gcc
CFLAGS = -Wall -Wextra -pedantic -std=c99

SRCS = main.c
OBJS = $(SRCS:.c=.o)
EXEC = myprog

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(EXEC) $(OBJS)
