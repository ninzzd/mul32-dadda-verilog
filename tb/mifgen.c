#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
/*
    assign mask_a = 32'h8020_0003;
    assign seed_a = 32'h0000_0001;
    assign mask_b = 32'h8000_0063;
    assign seed_b = 32'hDEAD_BEEF;
*/
int lfsr32(unsigned int seed, unsigned int mask, unsigned int n, unsigned int* outputs){
    outputs[0] = seed;
    for(int i = 1;i < n;i++){
        unsigned int xor = 0;
        unsigned int masked_seed = outputs[i-1] & mask;
        for(int j = 0;j < 32;j++){
            xor ^= (masked_seed >> j)%2;
        }
        outputs[i] = (outputs[i-1] << 1) | xor;
    }
    return 0;
}
int main(){
    int n;
    scanf("%d",&n);
    unsigned int* lfsr_a = (unsigned int*)malloc(n*sizeof(unsigned int));
    unsigned int* lfsr_b = (unsigned int*)malloc(n*sizeof(unsigned int));
    lfsr32(0x00000001,0x80200003,n,lfsr_a);
    lfsr32(0xDEADBEEF,0x80000063,n,lfsr_b);
    printf("LFSR A:\n");
    for(int i = 0;i < n;i++){
        printf("[%d]: 0x%X = %u\n",i,lfsr_a[i],lfsr_a[i]);
    }
    printf("LFSR B:\n");
    for(int i = 0;i < n;i++){
        printf("[%d]: 0x%X = %u\n",i,lfsr_b[i],lfsr_b[i]);
    }
    return 0;
}