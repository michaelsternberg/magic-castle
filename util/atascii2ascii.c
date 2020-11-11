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
            case 0x9b: 
                ch = '\n';
                break;
            case 0x09:
                ch = '\t';
                break;
            case 0x7f:
                ch = '\t';
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
    fprintf(stderr, "Usage: atascii2ascii <input_file>\n");
    fprintf(stderr, "Usage: atascii2ascii - (use stdin)\n");
    fprintf(stderr, "Output sent to stdout\n");
    return;
}
