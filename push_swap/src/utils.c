#include "../includes/push_swap.h"

t_int	*ft_last(t_int *lst)
{
	t_int	*curr;

	curr = lst;
	if (!curr)
		return (NULL);
	while (curr->next)
		curr = curr->next;
	return (curr);
}

t_int	*ft_before_last(t_int *lst)
{
	t_int	*curr;

	curr = lst;
	if (!curr)
		return (NULL);
	while (curr->next->next)
		curr = curr->next;
	return (curr);
}

t_int	*new_node(int value)
{
	t_int	*temp;

	temp = (t_int *)malloc(sizeof(t_int));
	if (!temp)
		exit(1);
	temp->n = value;
	temp->next = NULL;
	temp->index = 0;
	return (temp);
}

void	ft_addback(t_int *lst, int value)
{
	t_int	*temp;
	t_int	*last;

	temp = new_node(value);
	last = ft_last(lst);
	last->next = temp;
	temp->prev = last;
}

t_int	*init(int ac, char **av)
{
	t_int	*temp;
	int		i;

	if (!av)
		return (NULL);
	temp = new_node(ft_atoi(av[1]));
	i = 2;
	while (i < ac)
	{
		ft_addback(temp, ft_atoi(av[i]));
		i++;
	}
	return (temp);

	
}
	