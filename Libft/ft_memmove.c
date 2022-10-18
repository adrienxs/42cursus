/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memmove.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/15 12:13:43 by asirvent          #+#    #+#             */
/*   Updated: 2022/06/16 16:36:06 by asirvent         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memmove(void *dst, const void *src, size_t n)
{
	if ((char *)src < (char *)dst)
	{
		while (n--)
			((char *)dst)[n] = ((char *)src)[n];
	}
	else
		ft_memcpy((char *)dst, (char *)src, n);
	return (dst);
}
