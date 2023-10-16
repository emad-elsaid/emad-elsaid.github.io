#youtube_video

+ [Estimate Repo](https://github.com/emad-elsaid/estimate)

# Current implementation

```c
#include <dirent.h>
#include <stdbool.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>

#define TEMPLATE_START "<%"
#define TEMPLATE_END "%>"

char *moveToChar(char *s, char c) {
  while(*s!=0 && *s != c) s++;
  return s;
}

bool startsWith(char *s, char *prefix) {
  while(*prefix != 0 && *s != 0 && *prefix == *s ) {
    s++;
    prefix++;
  }
  return *prefix == 0;
}

char *moveToStr(char *s, char *substr) {
  for (; *(s = moveToChar(s, *substr)) != 0 && !startsWith(s, substr); s++);
  return s;
}

char *moveToStart(char *c) {return moveToStr(c, TEMPLATE_START);}
char *moveToEnd(char *c) {return moveToStr(c, TEMPLATE_END);}

char *skipStr(char *s, char *substr) {return s + strlen(substr);}
char *skipStart(char *c) { return skipStr(c, TEMPLATE_START); }
char *skipEnd(char *c) { return skipStr(c, TEMPLATE_END); }

void printEval(FILE *src, char *start, char *end) {
  fprintf(src, "StringWrite(w, ");
  while (start != end && *start != 0) {
    fprintf(src, "%c", *start);
    start++;
  }
  fprintf(src, ");\n");
}

void printFromTo(FILE *src, char *start, char *end) {
  while(start!=end && *start != 0 ){
    fprintf(src, "%c", *start);
    start++;
  }
}

void printString(FILE *src, char *start, char *end) {
  fprintf(src, "StringWrite(w, \"");
  while (start != end && *start != 0) {
    if (*start == '\"') {
      fprintf(src, "\\%c", *start);
    } else if (*start == '\n') {
      fprintf(src, "\"\n\"");
    } else {
      fprintf(src, "%c", *start);
    }
    start++;
  }
  fprintf(src, "\");\n");
}

void convertContent(FILE *src, char *content) {
  char *offset = content;
  while (*offset != 0) {
    char *nextOpen = moveToStart(offset);
    if (*nextOpen == 0){
      printString(src, offset, nextOpen);
      return;
    }

    printString(src, offset, nextOpen);

    offset = skipStart(nextOpen);
    if (*offset == 0) {
      fprintf(stderr, "Can't find end of template: \n\t%s", content);
      return;
    }

    char *nextClose = moveToEnd(offset);
    if(*offset == '='){
      printEval(src, offset+1, nextClose);
    }else{
      printFromTo(src, offset, nextClose);
    }

    offset = skipEnd(nextClose);
  }
}

char *FileContent(const char *path) {
  FILE *f = fopen(path, "r");
  if (f == NULL) {
    return NULL;
  }

  fseek(f, 0, SEEK_END);
  int size = ftell(f);
  char *content = malloc(size + 1);

  fseek(f, 0, SEEK_SET);
  fread(content, 1, size, f);
  content[size] = 0;
  fclose(f);

  return content;
}

void strreplace(char *c, char *replace, char with) {
  for(char *rr = replace; *rr != 0; rr++)
    for(char *cc = c; *cc != 0; cc++)
      if(*cc == *rr )
        *cc = with;
}

void processFile(FILE *header, FILE *src, char *f) {
  fprintf(stderr, "Processing file: %s\n", f);
  char *content = FileContent(f);

  char *funcName = strdup(f);
  strreplace(funcName, "/.", '_');
  fprintf(header, "char *%s(void *);\n", funcName);
  fprintf(src, "char *%s(void *input) {\n", funcName);
  fprintf(src, "String *w = StringNew(NULL);\n");
  free(funcName);

  convertContent(src, content);
  free(content);

  fprintf(src, "char *ret = w->value;\nfree(w);\nreturn ret;\n }\n");
}

void processDir(char *dir) {
  DIR *dfd;
  if ((dfd = opendir(dir)) == NULL) {
    fprintf(stderr, "Can't open %s\n", dir);
    return;
  }

  FILE *header = fopen("views_funcs.h", "w");
  FILE *src = fopen("views_funcs.c", "w");

  char filename_qfd[100];
  struct dirent *dp;

  fprintf(header, "#include \"./string.h\"\n");
  fprintf(src, "#include \"views_includes.h\"\n#include \"./string.h\"\n");

  while ((dp = readdir(dfd)) != NULL) {
    struct stat stbuf;
    sprintf(filename_qfd, "%s/%s", dir, dp->d_name);
    if (stat(filename_qfd, &stbuf) == -1) {
      printf("Unable to stat file: %s\n", filename_qfd);
      continue;
    }

    if ((stbuf.st_mode & S_IFMT) == S_IFDIR) {
      continue;
    } else {
      processFile(header, src, filename_qfd);
    }
  }

  fclose(header);
  fclose(src);
  closedir(dfd);
}


int main() {
  processDir("views");
}
```