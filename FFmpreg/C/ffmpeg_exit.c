// bomberfish
// ffmpeg_exit.c – FFmpreg
// created on 2025-05-08

#include <stdio.h>

int FFmpeg_exit(int ret) {
    printf("FFmpeg exited with code %d\n", ret);
    return ret;
}
