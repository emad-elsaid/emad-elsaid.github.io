* Basic webserver in C using [libmicrohttpd](https://www.gnu.org/software/libmicrohttpd/tutorial.html)

```c
#include <microhttpd.h>
#include <time.h>
#include <string.h>
#include <stdio.h>

#define PORT 8888

void elapsed_format(clock_t start, clock_t end) {
  double s = ((double)(end - start)) / CLOCKS_PER_SEC;

  if (s >= 1) {
    printf("%.2fs", s);
    return;
  }

  s *= 1000;

  if (s >= 1) {
    printf("%.2fms", s);
    return;
  }

  s *= 1000;
  printf("%.2fμs", s);
  return;
}

enum MHD_Result router(
                       void *cls,
                       struct MHD_Connection *conn,
                       const char *url,
                       const char *method,
                       const char *version,
                       const char *upload_data,
                       size_t *upload_data_size,
                       void **con_cls
                       ) {
  clock_t start = clock();


  const char *page = "<html><body>Hello, browser!</body></html>";
  struct MHD_Response *response = MHD_create_response_from_buffer(strlen(page), (void *)page, MHD_RESPMEM_PERSISTENT);
  enum MHD_Result ret = MHD_queue_response(conn, MHD_HTTP_OK, response);

  MHD_destroy_response(response);

  clock_t end = clock();

  printf("%s [", method);
  elapsed_format(start, end);
  printf("] %s\n", url);

  return ret;
}


int main() {
  struct MHD_Daemon *daemon = MHD_start_daemon(MHD_USE_INTERNAL_POLLING_THREAD, PORT, NULL, NULL, &router, NULL, MHD_OPTION_END);
  if (NULL == daemon) return 1;

  printf("Server started at: http://localhost:%d\nPress any key to exit...\n", PORT);
  getchar();

  MHD_stop_daemon(daemon);
  return 0;
}
```

Compiles with:
```shell
cc server.c -o hellobrowser `pkg-config --cflags --libs libmicrohttpd`
```

#c