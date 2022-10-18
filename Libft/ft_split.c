/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_split.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/30 16:32:02 by asirvent          #+#    #+#             */
/*   Updated: 2022/07/17 19:25:54 by asirvent         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

static size_t	ft_count_words(char *s, char x)
{
	size_t	c;
	size_t	i;

	c = 0;
	i = 0;
	if (!s[0])
		return (c);
	while (s[i])
	{
		if (s[i] != x && (s[i + 1] == x || s[i + 1] == '\0'))
			c++;
		i++;
	}
	return (c);
}

static char	**ft_free(char **s)
{
	int	i;

	i = 0;
	while (s[i])
		free(s[i++]);
	free(s);
	return (NULL);
}

static char	**ft_ini(const char *s, char x, char **str)
{
	int	i;
	int	j;
	int	ini;

	i = 0;
	j = 0;
	ini = 0;
	while (s[i])
	{
		if (i == 0 && s[i] != x)
			ini = i;
		if (i > 0 && s[i] != x && s[i - 1] == x)
			ini = i;
		if (s[i] != x && (s[i + 1] == x || s[i + 1] == '\0'))
		{
			str[j] = ft_substr(s, ini, (i + 1) - ini);
			if (!str[j++])
				return (ft_free(str));
		}
		i++;
	}
	str[j] = NULL;
	return (str);
}

char	**ft_split(char const *s, char c)
{
	char	**str;
	int		i;

	i = 0;
	str = malloc(sizeof(char *) * (ft_count_words((char *)s, c) + 1));
	if (!str)
		return (NULL);
	str = ft_ini(s, c, str);
	return (str);
}
