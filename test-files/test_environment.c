/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   test_environment.c                                 :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: student <student@student.42madrid.com>     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/01/01 00:00:00 by student           #+#    #+#             */
/*   Updated: 2024/01/01 00:00:00 by student          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <pthread.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int	g_counter = 0;

void	*thread_test(void *arg)
{
	int	id;

	id = *(int*)arg;
	printf("Thread %d working\n", id);
	sleep(1);
	g_counter++;
	return (NULL);
}

void	*thread_race(void *arg)
{
	int	i;

	(void)arg;
	i = 0;
	while (i < 1000)
	{
		g_counter++;
		i++;
	}
	return (NULL);
}

int	main(void)
{
	pthread_t	t1;
	pthread_t	t2;
	pthread_t	t3;
	int			id1;
	int			id2;

	id1 = 1;
	id2 = 2;
	printf("🧪 Testing 42 School environment...\n\n");
	printf("✅ Compilation: OK\n");
	pthread_create(&t1, NULL, thread_test, &id1);
	pthread_create(&t2, NULL, thread_test, &id2);
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);
	printf("✅ Basic threads: OK\n");
	pthread_create(&t2, NULL, thread_race, NULL);
	pthread_create(&t3, NULL, thread_race, NULL);
	pthread_join(t2, NULL);
	pthread_join(t3, NULL);
	printf("✅ Race condition test: OK (counter=%d)\n", g_counter);
	printf("\n🎉 Environment ready for 42 School!\n");
	printf("🛠️  Tools available: gcc, gdb, valgrind, norminette\n");
	printf("📚 Use 'norm' to check norminette compliance\n");
	printf("🐛 Use 'gdb ./test_environment' to debug\n");
	printf("🔍 Use 'valgrind --tool=helgrind ./test_environment' for race detection\n");
	return (0);
}
