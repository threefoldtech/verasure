#include <stdio.h>
#include <string.h>
#include <jerasure.h>
#include <reed_sol.h>
#include <stdlib.h>
#include <math.h>
#include "jerasure-simple.h"

int main() {
    erasure_t *erasure;
    erasure = erasure_new(16, 4);

    char *data = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer consectetur accumsan augue, at pharetra libero aliquet sed. Morbi accumsan nulla facilisis, gravida nulla et, interdum sem. Aliquam est turpis, congue at ultricies non, suscipit sed ante. Nullam commodo velit a scelerisque dapibus. In hac habitasse platea dictumst. Duis non tincidunt arcu. Maecenas molestie molestie dolor in luctus. Duis ultricies turpis eget diam finibus, in gravida arcu viverra. Ut nibh dolor, cursus vitae orci ut, dictum convallis.";
    shards_t *shards = erasure_encode(erasure, data, strlen(data));

    for(int i = 0; i < erasure->k; i++) {
        printf("<%.*s>\n", (int) shards->blocksize, shards->data[i]);
    }

    for(int i = 0; i < erasure->m; i++) {
        printf("<%.*s>\n", (int) shards->blocksize, shards->parity[i]);
    }

    free(shards->data[7]);
    free(shards->data[9]);
    free(shards->parity[2]);
    shards->data[7] = NULL;
    shards->data[9] = NULL;
    shards->parity[2] = NULL;

    buffer_t *buffer = erasure_decode(erasure, shards);
    printf(">> %s\n", buffer->data);

    buffer_free(buffer);
    shards_free(shards);
    erasure_free(erasure);

    return 0;
}

