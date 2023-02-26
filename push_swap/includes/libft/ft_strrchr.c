/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strrchr.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/16 16:33:07 by asirvent          #+#    #+#             */
/*   Updated: 2022/07/18 13:57:26 by asirvent         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strrchr(const char *s, int c)
{
	size_t		len;
	const char	*ini;

	ini = s;
	len = ft_strlen(s);
	s = s + len;
	while (s >= ini)
	{
		if (*s == (const char)c)
			return ((char *)s);
		s--;
	}
	return (NULL);
}
