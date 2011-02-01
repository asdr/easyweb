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

int main (int argc, char** argv) {

  

}
