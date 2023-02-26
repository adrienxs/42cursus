/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strlcat.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/15 12:30:40 by asirvent          #+#    #+#             */
/*   Updated: 2022/07/12 15:09:52 by asirvent         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

size_t	ft_strlcat(char *dst, const char *src, size_t dstsize)
{
	size_t	c;
	size_t	i;

	if (dstsize <= ft_strlen(dst))
		return (dstsize + ft_strlen(src));
	c = ft_strlen(dst);
	i = 0;
	while (src[i] && c + 1 < dstsize)
		dst[c++] = src[i++];
	dst[c] = '\0';
	return (ft_strlen(dst) + ft_strlen(&src[i]));
}
