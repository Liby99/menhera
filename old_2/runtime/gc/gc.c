#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

bool is_pointer(int n) {
    return (n & 3) == 0;
}

bool is_marked(int * ptr) {
    return *ptr == 1;
}

int * mark_tuple(int * ptr, int * max_addr) {

    // First check if the tuple is already marked or NULL
    if (ptr == NULL || is_marked(ptr)) {
        return ptr > max_addr ? ptr : max_addr;
    }

    // Then recursively mark the tuple.
    *ptr = 1;
    int len = *(ptr + 1);
    max_addr = max_addr > ptr ? max_addr : ptr;
    for (int i = 0; i < len; i++) {
        int n = *(ptr + 2 + i);
        if (is_pointer(n)) {
            int * v = mark_tuple((int *) n, max_addr);
            max_addr = max_addr > v ? max_addr : v;
        }
    }
    return max_addr;
}

int * mark(int * stack_top, int * first_frame, int * stack_bottom, int * max_addr) {
    
    // Go through the current stack frame
    for (int * i = stack_top; i < first_frame; i++) {
        if (is_pointer(*i)) {
            int * ptr = (int *) i;
            if (ptr != NULL) {
                max_addr = mark_tuple((int *) *ptr, max_addr);
            }
        }
    }
    
    // Check if the current stack frame is the lowest one
    if (first_frame >= stack_bottom) {
        
        // Then don't recurse
        return max_addr;
    }
    else {

        // If not, recursively go to the previous stack frame
        return mark(first_frame + 2, (int *) (*first_frame), stack_bottom, max_addr);
    }
}

void update_tuple(int * tup_ptr) {

    // Go through the curr tuple
    int len = *(tup_ptr + 1);
    for (int i = 0; i < len; i++) {

        // Get the ptr pointing to the ith elem of tuple
        int * ptr = tup_ptr + 2 + i;
        if (is_pointer(*ptr)) {

            // If that elem is a pointer, get that tuple
            int * that_tup = (int *) (*ptr);
            
            // Check if that tuple is NULL
            if (that_tup != NULL) {

                // Cache that tuple's new forwarded position and update
                int * new_that_tup = *that_tup & (~3);
                *ptr = new_that_tup;

                // Recursively update that tup
                update_tuple(that_tup);
            }
        }
    }
}

void update_stack(int * stack_top, int * first_frame, int * stack_bottom) {
    
    // Go through current stack frame
    for (int * i = stack_top; i < first_frame; i++) {
        if (is_pointer(*i)) {
            int * stack_ptr = (int *) i;
            int * heap_ptr = (int *) (*stack_ptr);
            if (heap_ptr != NULL) {
                *stack_ptr = *heap_ptr & (~3);
                update_tuple((int *) (*stack_ptr));
            }
        }
    }

    // Recursively go to the previous stack frame
    if (first_frame < stack_bottom) {
        update_stack(first_frame + 2, (int *) (*first_frame), stack_bottom);
    }
}

void forward(int * stack_top, int * first_frame, int * stack_bottom, int * heap_start, int * max_addr) {
   
    // First set the heap new values
    int * addr = heap_start;
    int * i = heap_start;
    while (i <= max_addr) {
        if (*i == 1) {
            *i |= (int) addr;
            addr += *(i + 1) + 2;
        }
        i += *(i + 1) + 2;
    }

    // Then traverse the stack and update to new value
    update_stack(stack_top, first_frame, stack_bottom);
}

int * compact(int * heap_start, int * max_addr) {

    // Compact the heap
    int * i = heap_start;
    int * addr = heap_start;
    while (i <= max_addr) {
        if (*i & 1 == 1) {
            *addr = 0;
            int len = *(i + 1);
            *(addr + 1) = len;
            for (int j = 0; j < len; j++) {
                *(addr + 2 + j) = *(i + 2 + j);
            }
            addr += 2 + len;
        }
        i += *(i + 1) + 2;
    }
    return addr;
}

int * gc(int * stack_bottom, int * first_frame, int * stack_top, int * heap_start, int * heap_end, int * alloc_ptr) {

    // First do the marking
    int * max_addr = mark(stack_top, first_frame, stack_bottom, NULL);

    // Then do the forwarding
    forward(stack_top, first_frame, stack_bottom, heap_start, max_addr);
    
    // Finally compact the heap
    int * new_ebx = compact(heap_start, max_addr);

    // Return the new ebx
    return new_ebx;
}
