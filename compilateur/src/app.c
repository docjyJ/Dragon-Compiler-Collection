#include "app.h"
#include <argp.h>
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
extern int yyparse();

void yyerror(const char *msg) {
    fprintf(stderr, "error: '%s' at line %d.\n", msg, yylineno);
    exit(1);
}

// const char *argp_program_version = "argp-ex4 1.0";
// const char *argp_program_bug_address = "<bug-gnu-utils@prep.ai.mit.edu>";

static char doc[] = "Compile simple C code to a Dragon program.";

static char args_doc[] = "[INPUT_FILE]";

static struct argp_option options[] = {
    {"output", 'o', "FILE", 0, "Output to FILE instead of standard output", 0},
    {"asm", 'a', 0, 0, "Output assembly code instead of binary", 0},
    {"hint-srcs", 's', 0, 0, "Output hint sources between instructions, only with assembly", 0},
    {0}};

struct arguments {
    char *input_file;
    char *output_file;
    unsigned int asm_mode : 1;
    unsigned int hint_srcs_mode : 1;
};

static error_t parse_opt(int key, char *arg, struct argp_state *state) {
    struct arguments *arguments = state->input;
    switch (key) {
        case 'o':
            arguments->output_file = arg;
            break;
        case 'a':
            arguments->asm_mode = 1;
            break;
        case 's':
            arguments->hint_srcs_mode = 1;
            break;
        case ARGP_KEY_ARG:
            if (state->arg_num > 0) // Too many arguments.
                argp_usage(state);
            arguments->input_file = arg;
            break;

        case ARGP_KEY_END:
            // if (state->arg_num < 0) // Not enough arguments.
            //    argp_usage (state);
            break;
        default:
            return ARGP_ERR_UNKNOWN;
    }
    return 0;
}

static struct argp argp = {options, parse_opt, args_doc, doc, 0, 0, 0};
struct arguments arguments = {0};

int main(int argc, char **argv) {
    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (arguments.hint_srcs_mode && !arguments.asm_mode) {
        fprintf(stderr, "error: hint sources can only be output with assembly code.\n");
        exit(1);
    }

    if (arguments.input_file != NULL)
        freopen(arguments.input_file, "r", stdin);
    if (arguments.output_file != NULL)
        freopen(arguments.output_file, "w", stdout);

    return yyparse();
}

void write_output(inst s) {
    if (!arguments.asm_mode)
        printf("%c%c%c%c", s.bin[0], s.bin[1], s.bin[2], s.bin[3]);
    else if (s.code == NULL)
        printf("Stop ! // No code here ???\n");
    else if (arguments.hint_srcs_mode && s.hint != NULL)
        printf("%s%s", s.hint, s.code);
    else
        printf("%s", s.code);
}
