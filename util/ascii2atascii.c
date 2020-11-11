#include <stdio.h>
#include <string.h>

void display_usage(void);

int main (int argc, char* argv[])
{
    FILE* fp; 
    unsigned char ch;

    if (argc != 2)
    {
        display_usage();
        return(1);
    }

    if (strcmp(argv[1], "-") == 0)
        fp = stdin;
    else
        fp = fopen(argv[1], "r");

    if (fp == NULL)
    {
        fprintf (stderr, "Unable to open [%s] for read\n", argv[1]);
        return(1);
    }

    ch = fgetc(fp);
    while (!feof(fp))
    {
        switch (ch)
        {
            case '\n': 
                ch = 0x9b;
                break;
            case '\t':
                ch = 0x09;
                break;
        }             
        fputc(ch, stdout);
        ch = fgetc(fp);
    }

    fclose(fp);
    return(0);
}

void display_usage(void)
{
    fprintf(stderr, "Usage: ascii2atascii <input_file>\n");
    fprintf(stderr, "Usage: ascii2atascii - (use stdin)\n");
    fprintf(stderr, "Output sent to stdout\n");
    return;
}
