/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   fcalloc.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: asirvent <asirvent@student.42barcel>       +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/05/21 19:29:19 by asirvent          #+#    #+#             */
/*   Updated: 2022/06/27 18:16:32 by asirvent         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	*ft_calloc(size_t count, size_t size)
{
	void	*dst;

	dst = malloc(count * size);
	if (dst == NULL)
		return (NULL);
	ft_bzero(dst, count * size);
	return (dst);
}
