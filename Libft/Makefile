# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/05/10 20:20:31 by asirvent          #+#    #+#              #
#    Updated: 2022/07/17 19:10:07 by asirvent         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME =	libft.a

SRCS = ft_isalnum.c		\
	   ft_isdigit.c		\
	   ft_isalpha.c		\
	   ft_isascii.c		\
	   ft_memset.c		\
	   ft_bzero.c		\
	   ft_memcpy.c		\
	   ft_isprint.c		\
	   ft_strlen.c		\
	   ft_memmove.c		\
	   ft_strlcpy.c		\
	   ft_strlcat.c		\
	   ft_toupper.c		\
	   ft_tolower.c		\
	   ft_strchr.c		\
	   ft_strrchr.c		\
	   ft_strncmp.c		\
	   ft_memchr.c		\
	   ft_memcmp.c		\
	   ft_strnstr.c		\
	   ft_atoi.c		\
	   ft_calloc.c		\
	   ft_strdup.c		\
	   ft_substr.c		\
	   ft_strjoin.c		\
	   ft_strtrim.c		\
	   ft_itoa.c		\
	   ft_strmapi.c		\
	   ft_striteri.c	\
	   ft_putchar_fd.c	\
	   ft_putstr_fd.c	\
	   ft_putendl_fd.c	\
	   ft_putnbr_fd.c	\
	   ft_split.c		\

HDR = libft.h

OBJ = $(SRCS:.c=.o)

CFLAGS = -Wall -Werror -Wextra

%.o :	%.c $(HDR)
		@$(CC) $(CFLAGS) -c $< -o $@

all:
		@$(MAKE) $(NAME)

$(NAME): $(OBJ)
		ar -rcs $(NAME) $(OBJ)
		@echo "Archivo compilado!"

re:
		@$(MAKE) fclean
		@$(MAKE) all

fclean:
		@$(MAKE) clean
		@echo "BORRANDO LIBRERIA"
		rm -f $(NAME)

clean:
		@echo "BORRANDO OBJECTOS"
		@rm -f $(OBJ)

.PHONY: all clean fclean re
