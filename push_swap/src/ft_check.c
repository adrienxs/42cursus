#include "../includes/push_swap.h"

static int	check_int(char *num, int *c)
{
	int	i;

	i = 0;
	if (num[i] == '-')
		i++;
	if (!num[i])
		return (0);
	while (num[i])
	{
		if (!ft_isdigit(num[i]))
		{
			red();
			printf("\rinvalid number\t\tKO!\n");
			*c = 1;
			return (0);
		}
		i++;
	}
	return (1);
}

static int	check_max(char *num, int *c)
{
	int	len;

	len = ft_strlen(num);
	if (len > 11)
		return (0);
	if ((len == 11 && num[0] != '-')
		|| (len == 11 && ft_strncmp(num, "-2147483648", 11) > 0)
		|| (len == 10 && ft_strncmp(num, "2147483647", 10) > 0))
	{
		*c = 1;
		return (0);
	}
	return (1);
}

static int	check_dup(char **av, int i, int size, int *c)
{
	int	j;

	j = i + 1;
	while (j < size)
	{
		if (!ft_strncmp(av[i], av[j], 11))
		{
			red();
			printf("duplicated numbers\n");
			reset();
			*c = 1;
			return (0);
		}
		j++;
	}
	return (1);
}

void	ft_check(int ac, char **av)
{
	int	i;
	int	c;

	c = 0;
	i = 1;
	yellow();
	printf("checking numbers...\n");
	while (i < ac)
	{
		check_int(av[i], &c);
		check_max(av[i], &c);
		check_dup(av, i, ac, &c);
		if (c > 0)
		{
			write(2, "[!]Error\n", 9);
			exit(1);
		}
		i++;
	}
	green();
	printf("valid numbers\t\tOK!\n");
	reset();
}