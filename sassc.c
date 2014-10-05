#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>
#include <sass_interface.h>

#define BUFSIZE 512
#ifdef _WIN32
#define PATH_SEP ';'
#else
#define PATH_SEP ':'
#endif

int output(int error_status, char* error_message, char* output_string, const char* outfile) {
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
    char* source_map_file = 0;
    struct sass_file_context* ctx = sass_new_file_context();

    ctx->options = options;
    ctx->input_path = input_path;
    ctx->output_path = outfile;

    sass_compile_file(ctx);
    ret = output(ctx->error_status, ctx->error_message, ctx->output_string, outfile);
    if (ctx->options.source_map_file) {
      ret = output(ctx->error_status, ctx->error_message, ctx->source_map_string, ctx->options.source_map_file);
    }

    free(source_map_file);
    sass_free_file_context(ctx);
    return ret;
}

struct
{
    char* style_string;
    int output_style;
} style_option_strings[] = {
    { "compressed", SASS_STYLE_COMPRESSED },
    //{ "compact", SASS_STYLE_COMPACT },
    //{ "expanded", SASS_STYLE_EXPANDED },
    { "nested", SASS_STYLE_NESTED }
};

#define NUM_STYLE_OPTION_STRINGS \
    sizeof(style_option_strings) / sizeof(style_option_strings[0])

void print_usage(char* argv0) {
    int i;
    printf("Usage: %s [options] [INPUT] [OUTPUT]\n\n", argv0);
    printf("Options:\n");
    printf("   -s, --stdin             Read input from standard input instead of an input file.\n");
    printf("   -t, --style NAME        Output style. Can be:");
    for(i = NUM_STYLE_OPTION_STRINGS - 1; i >= 0; i--) {
        printf(" %s", style_option_strings[i].style_string);
        printf(i == 0 ? ".\n" : ",");
    }
    printf("   -l, --line-numbers      Emit comments showing original line numbers.\n");
    printf("       --line-comments\n");
    printf("   -I, --load-path PATH    Set Sass import path.\n");
    printf("   -m, --sourcemap         Emit source map.\n");
    printf("   -M, --omit-map-comment  Omits the source map url comment.\n");
    printf("   -p, --precision         Set the precision for numbers.\n");
    printf("   -h, --help              Display this help message.\n");
    printf("\n");
}

void invalid_usage(char* argv0) {
    fprintf(stderr, "See '%s -h'\n", argv0);
    exit(EXIT_FAILURE);
}

int main(int argc, char** argv) {
    char *outfile = 0;
    int from_stdin = 0;
    bool generate_source_map = false;
    struct sass_options options = { 0 };
    options.output_style = SASS_STYLE_NESTED;
    options.image_path = "images";
    char *include_paths = NULL;
    options.precision = 5;

    int c, i;
    int long_index = 0;
    static struct option long_options[] =
    {
        { "stdin",              no_argument,       0, 's' },
        { "load-path",          required_argument, 0, 'I' },
        { "style",              required_argument, 0, 't' },
        { "line-numbers",       no_argument,       0, 'l' },
        { "line-comments",      no_argument,       0, 'l' },
        { "sourcemap",          no_argument,       0, 'm' },
        { "omit-map-comment",   no_argument,       0, 'M' },
        { "precision",          required_argument, 0, 'p' },
        { "help",               no_argument,       0, 'h' }
    };
    while ((c = getopt_long(argc, argv, "hslmMt:I:", long_options, &long_index)) != -1) {
        switch (c) {
        case 's':
            from_stdin = 1;
            break;
        case 'I':
            if (!include_paths) {
                include_paths = strdup(optarg);
            } else {
                char *old_paths = include_paths;
                include_paths = malloc(strlen(old_paths) + 1 + strlen(optarg) + 1);
                sprintf(include_paths, "%s%c%s", old_paths, PATH_SEP, optarg);
                free(old_paths);
            }
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
            options.source_comments = true;
            break;
        case 'm':
            generate_source_map = true;
            break;
        case 'M':
            options.omit_source_map_url = true;
            break;
        case 'p':
            options.precision = atoi(optarg); // TODO: make this more robust
            if (options.precision < 0) options.precision = 5;
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

    options.include_paths = include_paths ? include_paths : "";

    if(optind < argc - 2) {
        fprintf(stderr, "Error: Too many arguments.\n");
        invalid_usage(argv[0]);
    }

    int result;
    if(optind < argc && strcmp(argv[optind], "-") != 0 && !from_stdin) {
        if (optind + 1 < argc) {
            outfile = argv[optind + 1];
        }
        if (generate_source_map && outfile) {
            const char* extension = ".map";
            char* source_map_file  = calloc(strlen(outfile) + strlen(extension) + 1, sizeof(char));
            strcpy(source_map_file, outfile);
            strcat(source_map_file, extension);
            options.source_map_file = source_map_file;
        }
        result = compile_file(options, argv[optind], outfile);
    } else {
        if (optind < argc) {
            outfile = argv[optind];
        }
        result = compile_stdin(options, outfile);
    }

    free(include_paths);

    return result;
}
