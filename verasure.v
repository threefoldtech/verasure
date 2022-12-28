[translated]
module main

#include "@VMODROOT/jerasure-simple.h"

#flag -I/usr/include/jerasure -I/usr/local/include/jerasure
#flag @VMODROOT/jerasure-simple.o
#flag -L/usr/lib64 -lJerasure
#flag -lm

struct Lldiv_t {
	quot i64
	rem  i64
}

struct Random_data {
	fptr      &int
	rptr      &int
	state     &int
	rand_type int
	rand_deg  int
	rand_sep  int
	end_ptr   &int
}

struct Drand48_data {
	__x     [3]u16
	__old_x [3]u16
	__c     u16
	__init  u16
	__a     i64
}

const ( // empty enum
	fp_nan       = 0
	fp_infinite  = 1
	fp_zero      = 2
	fp_subnormal = 3
	fp_normal    = 4
)

struct Erasure_t {
	k      int
	m      int
	w      int
	matrix &int
}

struct Shards_t {
	data_length   int
	parity_length int
	data          &&u8
	parity        &&u8
	aligned       usize
	blocksize     usize
	allocated     int
}

struct Buffer_t {
	data   &i8
	length usize
}

fn C.buffer_free(buffer &Buffer_t) voidptr

fn C.erasure_new(k int, m int) &Erasure_t

fn C.erasure_free(erasure &Erasure_t) voidptr

fn C.shards_free(shards &Shards_t) voidptr

fn C.erasure_encode(erasure &Erasure_t, data &i8, length usize) &Shards_t

fn C.erasure_decode(erasure &Erasure_t, shards &Shards_t) &Buffer_t

fn main() {
	erasure := &Erasure_t(0)
	erasure = C.erasure_new(16, 4)
	data := c'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer consectetur accumsan augue, at pharetra libero aliquet sed. Morbi accumsan nulla facilisis, gravida nulla et, interdum sem. Aliquam est turpis, congue at ultricies non, suscipit sed ante. Nullam commodo velit a scelerisque dapibus. In hac habitasse platea dictumst. Duis non tincidunt arcu. Maecenas molestie molestie dolor in luctus. Duis ultricies turpis eget diam finibus, in gravida arcu viverra. Ut nibh dolor, cursus vitae orci ut, dictum convallis.'
	shards := C.erasure_encode(erasure, data, unsafe { C.strlen(data) })
	for i := 0; i < erasure.k; i++ {
		C.printf(c'<%.*s>\n', int(shards.blocksize), shards.data[i])
	}
	for i := 0; i < erasure.m; i++ {
		C.printf(c'<%.*s>\n', int(shards.blocksize), shards.parity[i])
	}
	C.free(shards.data[7])
	C.free(shards.data[9])
	C.free(shards.parity[2])
	shards.data[7] = (unsafe { nil })
	shards.data[9] = (unsafe { nil })
	shards.parity[2] = (unsafe { nil })
	buffer := C.erasure_decode(erasure, shards)
	C.printf(c'>> %s\n', buffer.data)
	C.buffer_free(buffer)
	C.shards_free(shards)
	C.erasure_free(erasure)
	return
}
