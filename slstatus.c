#include <stdio.h>

#include "slstatus.h"
#include "util.h"


struct arg {
    const char *(*func)(const char *);
    const char *fmt;
    const char *args;
};

#include "config.h"

char buf[1024];


void slstatus_update(char* status, size_t max_len) {
    size_t i, len;
    int ret;
    const char *res;
    status[0] = '\0';
    for (i = len = 0; i < LEN(args); i++) {
        if (!(res = args[i].func(args[i].args)))
            res = unknown_str;

        if ((ret = esnprintf(status + len, max_len - len,
                        args[i].fmt, res)) < 0)
            break;

        len += ret;
    }
}
