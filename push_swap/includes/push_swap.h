#ifndef PUSH_SWAP_H
# define PUSH_SWAP_H

# include <stdlib.h>
# include <stdio.h>
# include <limits.h>
# include "libft/libft.h"

void	ft_check(int ac, char **av); /* ac: argument count, av: argument value */

void	red(void);

void	yellow(void);

void	green(void);

void	reset(void);

typedef struct s_int /* 'typedef' es para hacer un alias de un tipo de variable, 'struct s_int' seria ahora un tipo de variable */
{
	int				n; /* El num introducido en argv */
	int				index;
	struct s_int	*prev; 
	struct s_int	*next;
}					t_int; /* Esto es el alias asigndo a 'struct s_int' */

t_int	*init(int ac, char **av);
t_int	*init_b(int value);

t_int	*ft_last(t_int *lst);
t_int	*ft_before_last(t_int *lst);

void	swap(t_int **lst);
void	push(t_int **a, t_int **b);
void	rotate(t_int **lst);
void	rrotate(t_int **lst);

#endif