#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include "libsass/sass_interface.h"

#define BUFSIZE 512

int output(int error_status, char* error_message, char* output_string, char* outfile) {
    if (error_status) {
        if (error_message) {
            fprintf(stderr, "%s", error_message);
        } else {
            fprintf(stderr, "An error occured; no error message available.\n");
        }
        return 1;
    } else if (output_string) {
        if(outfile) {
            FILE* fp = fopen(outfile, "w");
            if(!fp) {
                perror("Error opening output file");
                return 1;
            }
            if(fprintf(fp, "%s", output_string) < 0) {
                perror("Error writing to output file");
                fclose(fp);
                return 1;
            }
            fclose(fp);
        }
        else {
            printf("%s", output_string);
        }
        return 0;
    } else {
        fprintf(stderr, "Unknown internal error.\n");
        return 2;
    }
}

int compile_stdin(struct sass_options options, char* outfile) {
    int ret;
    struct sass_context* ctx;
    char buffer[BUFSIZE];
    size_t size = 1;
    char *source_string = malloc(sizeof(char) * BUFSIZE);

    if(source_string == NULL) {
        perror("Allocation failed");
        exit(1);
    }

    source_string[0] = '\0';

    while(fgets(buffer, BUFSIZE, stdin)) {
        char *old = source_string;
        size += strlen(buffer);
        source_string = realloc(source_string, size);
        if(source_string == NULL) {
            perror("Reallocation failed");
            free(old);
            exit(2);
        }
        strcat(source_string, buffer);
    }

    if(ferror(stdin)) {
        free(source_string);
        perror("Error reading standard input");
        exit(2);
    }

    ctx = sass_new_context();
    ctx->options = options;
    ctx->source_string = source_string;
    sass_compile(ctx);
    ret = output(ctx->error_status, ctx->error_message, ctx->output_string, outfile);

    sass_free_context(ctx);
    free(source_string);
    return ret;
}

int compile_file(struct sass_options options, char* input_path, char* outfile) {
    int ret;
    struct sass_file_context* ctx = sass_new_file_context();

    ctx->options = options;
    ctx->input_path = input_path;

    sass_compile_file(ctx);
    ret = output(ctx->error_status, ctx->error_message, ctx->output_string, outfile);

    sass_free_file_context(ctx);
    return ret;
}

struct
{
    char* style_string;
    int output_style;
} style_option_strings[] = {
    { "compressed", SASS_STYLE_COMPRESSED },
    { "compact", SASS_STYLE_COMPACT },
    { "expanded", SASS_STYLE_EXPANDED },
    { "nested", SASS_STYLE_NESTED }
};

#define NUM_STYLE_OPTION_STRINGS \
    sizeof(style_option_strings) / sizeof(style_option_strings[0])

void print_usage(char* argv0) {
    int i;
    printf("Usage: %s [OPTION]... [FILE]\n\n", argv0);
    printf("Options:\n");
    printf("   -o OUTFILE     Write output to specified file.\n");

    printf("   -t NAME        Output style. Can be:");
    for(i = NUM_STYLE_OPTION_STRINGS - 1; i >= 0; i--) {
        printf(" %s", style_option_strings[i].style_string);
        printf(i == 0 ? ".\n" : ",");
    }

    printf("   -l             Emit comments showing original line numbers.\n");
    printf("   -I PATH        Set Sass import path.\n");
    printf("   -h             Display this help message.\n");
    printf("\n");
}

void invalid_usage(char* argv0) {
    fprintf(stderr, "See '%s -h'\n", argv0);
    exit(EXIT_FAILURE);
}

int main(int argc, char** argv) {
    char *outfile = 0;
    struct sass_options options;
    options.output_style = SASS_STYLE_NESTED;
    options.source_comments = 0;
    options.image_path = "images";
    options.include_paths = "";

    int c, i;
    while ((c = getopt(argc, argv, "ho:lt:I:")) != -1) {
        switch (c) {
        case 'o':
            outfile = optarg;
            break;
        case 'I':
            options.include_paths = optarg;
            break;
        case 't':
            for(i = 0; i < NUM_STYLE_OPTION_STRINGS; ++i) {
                if(strcmp(optarg, style_option_strings[i].style_string) == 0) {
                    options.output_style = style_option_strings[i].output_style;
                    break;
                }
            }
            if(i == NUM_STYLE_OPTION_STRINGS) {
                fprintf(stderr, "Invalid argument for -t flag: '%s'. Allowed arguments are:", optarg);
                for(i = 0; i < NUM_STYLE_OPTION_STRINGS; ++i) {
                    fprintf(stderr, " %s", style_option_strings[i].style_string);
                }
                fprintf(stderr, "\n");
                invalid_usage(argv[0]);
            }
            break;
        case 'l':
            options.source_comments = 1;
            break;
        case 'h':
            print_usage(argv[0]);
            return 0;
        case '?':
            /* Unrecognized flag or missing an expected value */
            /* getopt should produce it's own error message for this case */
            invalid_usage(argv[0]);
        default:
            fprintf(stderr, "Unknown error while processing arguments\n");
            return 2;
        }
    }

    if(optind < argc - 1) {
        fprintf(stderr, "Error: Too many arguments.\n");
        invalid_usage(argv[0]);
    }

    if(optind < argc && strcmp(argv[optind], "-") != 0) {
        return compile_file(options, argv[optind], outfile);
    } else {
        return compile_stdin(options, outfile);
    }
}
