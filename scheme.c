#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef enum
{
  PAIR, SYMBOL
} type_t;

typedef struct cell
{
  type_t type;
  void* car;
  void* cdr;
} cell_t;

void print(cell_t* exp)
{
  if (!exp)
  {
    printf("()");
  }
  else switch (exp->type)
  {
  case SYMBOL:
    printf("%s", (char*)(exp->car));
    break;

  default:
    printf("(");
    print(exp->car);
    printf(" . ");
    print(exp->cdr);
    printf(")");
  }
}

cell_t* make_symbol(char* s)
{
  cell_t* buffer = malloc(sizeof(cell_t));
  (*buffer).type = SYMBOL;
  (*buffer).car = s;
  (*buffer).cdr = NULL;
  return buffer;
}

cell_t* cons(cell_t* x, cell_t* y)
{
  cell_t* buffer = malloc(sizeof(cell_t));
  buffer->type = PAIR;
  buffer->car = x;
  buffer->cdr = y;
  return buffer;
}

int main(void)
{
  cell_t* x = cons(make_symbol("hoge"), make_symbol("fuga"));
  print(x);

  return EXIT_SUCCESS;
}

