/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strnstr.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/17 19:42:28 by asirvent          #+#    #+#             */
/*   Updated: 2022/07/17 19:23:32 by asirvent         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

char	*ft_strnstr(const char *hst, const	char *ndl, size_t len)
{
	size_t	i;
	size_t	j;

	i = 0;
	if (!ft_strlen(ndl))
		return ((char *)hst);
	while (i < len && hst[i])
	{
		j = 0;
		while (hst[i + j] == ndl[j] && ndl[j] && i + j < len)
			j++;
		if (!ndl[j])
			return ((char *)hst + i);
		else
			i++;
	}
	return (0);
}
