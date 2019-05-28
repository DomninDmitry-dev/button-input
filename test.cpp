/*
 * test.cpp
 *
 *  Created on: may 28, 2019
 *      Author: Dmitry Domnin
 */

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <linux/input.h>
#include <sys/select.h>

#define INPUT_DEVICE "/dev/input/event0"

int main(int argc, char **argv)
{
	int fd;
	struct input_event ev;
	int size = sizeof(ev);
	ssize_t bytesRead;

	printf("Start programm!\n");

	fd = open(INPUT_DEVICE, O_RDONLY);

	/* Let's open our input device */
	if(fd < 0){
		fprintf(stderr, "Error opening %s for reading", INPUT_DEVICE);
		exit(EXIT_FAILURE);
	}

	while(1)
	{
		bytesRead = read(fd, &ev, size);
		if(bytesRead < size) {
			/* Process read input error*/
			fprintf(stderr, "Read input error %s", INPUT_DEVICE);
			exit(EXIT_FAILURE);
		}

		if(ev.type == EV_KEY) {
			if(ev.code == BTN_0) {
				/* it concerns our button */
				printf("Value = %d\n", ev.value);
			}
		}
	}
	close(fd);
	return EXIT_SUCCESS;
}
