#include <stdio.h>
#include "libsass/sass_interface.h"

int main(int argc, char** argv)
{
	int ret;

	if (argc < 2) {
		printf("Usage: sassc [INPUT FILE]\n");
		return 0;
	}

	struct sass_file_context* ctx = sass_new_file_context();
	ctx->options.include_paths = "";
	ctx->options.image_path = "images";
	ctx->options.output_style = SASS_STYLE_NESTED;
	ctx->input_path = argv[1];

	sass_compile_file(ctx);

	if (ctx->error_status) {
		if (ctx->error_message)
			fprintf(stderr, "%s", ctx->error_message);
		else
			fprintf(stderr, "An error occured; no error message available.\n");
		ret = 1;
	}
	else if (ctx->output_string) {
		printf("%s", ctx->output_string);
		ret = 0;
	}
	else {
		fprintf(stderr, "Unknown internal error.\n");
		ret = 2;
	}

	sass_free_file_context(ctx);
	return ret;
}

