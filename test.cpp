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

#define INPUT_DEVICE "/dev/input/event1"

int main(int argc, char **argv)
{
	int fd;
	struct input_event event;
	ssize_t bytesRead;
	int ret;
	fd_set readfds;

	printf("Start programm!\n");
return EXIT_SUCCESS;
	while(1);

	fd = open(INPUT_DEVICE, O_RDONLY);

	/* Let's open our input device */
	if(fd < 0){
		fprintf(stderr, "Error opening %s for reading", INPUT_DEVICE);
		exit(EXIT_FAILURE);
	}

	while(1)
	{
		printf("Wait on fd for input\n");
		/* Wait on fd for input */
		FD_ZERO(&readfds);
		FD_SET(fd, &readfds);
		ret = select(fd + 1, &readfds, NULL, NULL, NULL);
		if (ret == -1) {
			fprintf(stderr, "select call on %s: an error ocurred", INPUT_DEVICE);
			break;
		}
		else if (!ret) { /* If we have decided to use timeout */
			fprintf(stderr, "select on %s: TIMEOUT", INPUT_DEVICE);
			break;
		}

		/* File descriptor is now ready */
		if (FD_ISSET(fd, &readfds)) {
			bytesRead = read(fd, &event, sizeof(struct input_event));
			//if(bytesRead == -1)
			/* Process read input error*/
			//if(bytesRead != sizeof(struct input_event))
			/* Read value is not an input even */
			/*
			* We could have done a switch/case if we had
			* many codes to look for
			*/
			if(event.code == BTN_0) {
				/* it concerns our button */
				if(event.value == 0){
					/* Process Release */
					printf("Value = 0");
				}
				else if(event.value == 1){
					/* Process KeyPress */
					printf("Value = 1");
				}
			}
		}
	}
	close(fd);
	return EXIT_SUCCESS;
}
