#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/epoll.h>
#include <unistd.h>

#include <sys/poll.h>

void addEvent(int epfd, int fd) {
  int fd;
  struct epoll_event event;

  event.events = EPOLLIN | EPOLLOUT;
  event.data.fd = fd;

  if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &event)) {
    perror("epoll_ctl(ADD)");
    exit(1);
  }
}

int main (void) {
  char buf[4096];
  int i, rc;
  int epfd;
  struct epoll_event events[2];
  int num;
  int numFds;
  int fd1, fd2;

  epfd = epoll_create(2);

  if (epfd < 0) {
    perror("epoll_create");
    return 1;
  }

  if ((fd1 = open("p1", O_RDONLY | O_NONBLOCK)) < 0) {
    perror("open_p1");
    return 1;
  }

  if ((fd2 = open("p2", O_RDONLY | O_NONBLOCK)) < 0) {
    perror("open_p2");
    return 1;
  }

  addEvent(epfd, fd1);
  addEvent(epfd, fd2);

  numFds = 2;
  while(numFds) {
    if ((num = epoll_wait(epfd, 
			  events, 
			  sizeof(events) / sizeof(*events),
			  -1)) <= 0) {
      perror("epoll_wait");
      return 1;
    }

    for (i = 0; i < num; ++i) {
      rc = read(events[i].data.fd, buf, sizeof(buf) - 1);
      if (rc < 0) {
	perror("read");
	return 1;
      }
      else if (!rc) {
	if (epoll_ctl(epfd, EPOLL_CTL_DEL, events[i].data.fd, &events[i])) {
	  perror("epoll_ctl(DEL)");
	  return 1;
	}

	close(events[i].data.fd);
	numFds--;
      }
      else {
	buf[rc] = '\0';
	printf("read: %s", buf);
      }
    }
  }

  close(epfd);
  return 0;
}
