/*
GUEST_MACOS.C

macOS-specific guest support.  The desktop updater's macOS no-op lives in
port/linux/src/updater.c, alongside its dedicated-server no-ops.
*/

#include "guest_host.h"
#include "../../../linux/src/update.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* The macOS host owns TLS. The desktop's master lists need GET requests;
the other methods belong to the dedicated server, which this port does not
run. */
int update_https_request(const char *method, const char *url, const char *headers, const void *body,
	unsigned long body_size, unsigned long maximum, struct update_response *response, char *error, int error_size)
{
	char *answer;
	int status, answer_size;

	(void)headers;
	(void)body;
	(void)body_size;
	if (strcmp(method, "GET"))
	{
		snprintf(error, (size_t)error_size, "the macOS guest sends HTTPS GET requests only");
		return 0;
	}
	if (maximum > 0x7ffffffeUL)
		maximum = 0x7ffffffeUL;
	answer = malloc((size_t)maximum + 1);
	if (!answer)
	{
		snprintf(error, (size_t)error_size, "out of memory");
		return 0;
	}
	if (!host_https_get(url, &status, response->headers, sizeof(response->headers), answer, (int)maximum,
		&answer_size, error, error_size))
	{
		free(answer);
		return 0;
	}
	if (answer_size < 0)
		answer_size = 0;
	answer[answer_size] = 0;
	response->status = status;
	response->body = answer;
	response->body_size = (unsigned long)answer_size;
	return 1;
}
