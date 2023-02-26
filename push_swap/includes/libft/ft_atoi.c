#include "libft.h"
#include <stdio.h>

int	ft_atoi(const char *n)
{
	int	m;
	int	b;
	int	i;

	i = 0;
	m = 1;
	b = 0;
	while (n[i] == ' ' || n[i] == '\f' || n[i] == '\n'
		|| n[i] == '\r' || n[i] == '\t' || n[i] == '\v')
		i++;
	if (n[i] == '+' || n[i] == '-')
	{
		if (n[i] == '-')
			m = -m;
		i++;
	}
	while (n[i] >= '0' && n[i] <= '9')
	{
		b = b * 10 + (n[i] - '0');
		i++;
	}
	return (b * m);
}
