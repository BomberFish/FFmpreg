// FFmpeg-iOS: Swift package to use FFmpeg in your iOS apps
// Copyright (C) 2023  Changbeom Ahn
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

#ifndef FFmpeg_h
#define FFmpeg_h
#if defined(__arm64__) || defined(__aarch64__)

#include "libavcodec/codec.h"
#include "libavcodec/codec_desc.h"

static int compare_codec_desc(const void *a, const void *b)
{
    const AVCodecDescriptor * const *da = a;
    const AVCodecDescriptor * const *db = b;

    return (*da)->type != (*db)->type ? FFDIFFSIGN((*da)->type, (*db)->type) :
           strcmp((*da)->name, (*db)->name);
}

static int get_codecs_sorted(const AVCodecDescriptor ***rcodecs)
{
    const AVCodecDescriptor *desc = NULL;
    const AVCodecDescriptor **codecs;
    unsigned nb_codecs = 0, i = 0;

    while ((desc = avcodec_descriptor_next(desc)))
        nb_codecs++;
    if (!(codecs = av_calloc(nb_codecs, sizeof(*codecs))))
        return AVERROR(ENOMEM);
    desc = NULL;
    while ((desc = avcodec_descriptor_next(desc)))
        codecs[i++] = desc;
    if (i != nb_codecs) {
        av_free(codecs);
        return AVERROR(EINVAL);
    }
    qsort(codecs, nb_codecs, sizeof(*codecs), compare_codec_desc);
    *rcodecs = codecs;
    return nb_codecs;
}

static const AVCodec *next_codec_for_id(enum AVCodecID id, void **iter,
                                        int encoder)
{
    const AVCodec *c;
    while ((c = av_codec_iterate(iter))) {
        if (c->id == id &&
            (encoder ? av_codec_is_encoder(c) : av_codec_is_decoder(c)))
            return c;
    }
    return NULL;
}

static char get_media_type_char(enum AVMediaType type)
{
    switch (type) {
        case AVMEDIA_TYPE_VIDEO:    return 'V';
        case AVMEDIA_TYPE_AUDIO:    return 'A';
        case AVMEDIA_TYPE_DATA:     return 'D';
        case AVMEDIA_TYPE_SUBTITLE: return 'S';
        case AVMEDIA_TYPE_ATTACHMENT:return 'T';
        default:                    return '?';
    }
}

static int print_codecs(int encoder)
{
    const AVCodecDescriptor **codecs;
    int i, nb_codecs = get_codecs_sorted(&codecs);

    if (nb_codecs < 0)
        return nb_codecs;

    printf("%s:\n"
           " V..... = Video\n"
           " A..... = Audio\n"
           " S..... = Subtitle\n"
           " .F.... = Frame-level multithreading\n"
           " ..S... = Slice-level multithreading\n"
           " ...X.. = Codec is experimental\n"
           " ....B. = Supports draw_horiz_band\n"
           " .....D = Supports direct rendering method 1\n"
           " ------\n",
           encoder ? "Encoders" : "Decoders");
    for (i = 0; i < nb_codecs; i++) {
        const AVCodecDescriptor *desc = codecs[i];
        const AVCodec *codec;
        void *iter = NULL;

        while ((codec = next_codec_for_id(desc->id, &iter, encoder))) {
            printf(" %c%c%c%c%c%c",
                   get_media_type_char(desc->type),
                   (codec->capabilities & AV_CODEC_CAP_FRAME_THREADS)   ? 'F' : '.',
                   (codec->capabilities & AV_CODEC_CAP_SLICE_THREADS)   ? 'S' : '.',
                   (codec->capabilities & AV_CODEC_CAP_EXPERIMENTAL)    ? 'X' : '.',
                   (codec->capabilities & AV_CODEC_CAP_DRAW_HORIZ_BAND) ? 'B' : '.',
                   (codec->capabilities & AV_CODEC_CAP_DR1)             ? 'D' : '.');

            printf(" %-20s %s", codec->name, codec->long_name ? codec->long_name : "");
            if (strcmp(codec->name, desc->name))
                printf(" (codec %s)", desc->name);

            printf("\n");
        }
    }
    av_free(codecs);
    return 0;
}


int FFmpeg_main(int, char**);

int FFprobe_main(int, char**);

int FFmpeg_exit(int ret);
#endif
#endif /* FFmpeg_h */
