/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_memcpy.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/13 18:23:57 by asirvent          #+#    #+#             */
/*   Updated: 2022/06/12 20:04:21 by asirvent         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_memcpy(void *dst, const void *src, size_t n)
{
	void	*aux;

	aux = dst;
	if (!dst && !src)
		return (0);
	while (n--)
		*(char *)dst++ = *(char *)src++;
	return (aux);
}
