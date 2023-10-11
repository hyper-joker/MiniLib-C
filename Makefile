NAME = libasm.so

AS = nasm

LD = ld

SRC = library.asm

OBJ = $(SRC:.asm=.o)

ASFLAGS = -f elf64 #-g

LDFLAGS = -shared

.PHONY : all clean fclean re

all : $(NAME)

$(NAME) : $(OBJ)
	$(LD) -o $(NAME) $(OBJ) $(LDFLAGS)

%.o : %.asm
	$(AS) $(ASFLAGS) -o $@ $<

clean :
	rm -f $(OBJ)

fclean : clean
	rm -f $(NAME)
re : fclean all