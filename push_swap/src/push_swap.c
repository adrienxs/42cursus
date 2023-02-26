#include "../includes/push_swap.h"

int	main(int ac, char **av)
{
	t_int	*a;
	t_int	*b;
	t_int	*tmpA;
	t_int	*tmpB;
	int		i;

	if (ac == 1)
	{
		printf("No args\n");
		return (0);
	}
	ft_check(ac, av);
	a = init(ac, av);
	b = init(ac, av);

	tmpA = a;
	green();
	while (tmpA)
	{
		printf("stack A: %d\n", tmpA->n);
		tmpA = tmpA->next;
	}
	reset();

	rrotate(&a);
	push(&a, &b);
	//rotate(&a);
	
	tmpA = a;
	tmpB = b;
	green();
	while (tmpA)
	{
		printf("new A: %d\n", tmpA->n);
		tmpA = tmpA->next;
	}
	while (tmpB)
	{
		printf("new B: %d\n", tmpB->n);
		tmpB = tmpB->next;
	}

	reset();
	exit(0);
}