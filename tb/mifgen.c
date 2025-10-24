#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
/*
    mask_a = 32'h8020_0003;
    seed_a = 32'h0000_0001;
    mask_b = 32'h8000_0063;
    seed_b = 32'hDEAD_BEEF;
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
/*
.mif file example:
DEPTH = 4096;
WIDTH = 64;
ADDRESS_RADIX = HEX;
DATA_RADIX = HEX;

CONTENT BEGIN
    000 : 0000_0000_0000_0000;
    001 : 0000_0000_0000_0001;
    [... many more entries ...]
    FFF : FFFF_FFFF_FFFF_FFFF;
END;
*/
int main(){
    FILE *f;
    int n;
    printf("Enter n (power of 2): \n");
    scanf("%d",&n);
    int m = n/2;
    f = fopen("res.mif","w");
    fprintf(f,"DEPTH = %d;\n",n);
    fprintf(f,"WIDTH = 64;\n");
    fprintf(f,"ADDRESS_RADIX = HEX;\n");
    fprintf(f,"DATA_RADIX = HEX;\n");
    fprintf(f,"CONTENT BEGIN\n");
    unsigned int* lfsr_a = (unsigned int*)malloc(n*sizeof(unsigned int));
    unsigned int* lfsr_b = (unsigned int*)malloc(n*sizeof(unsigned int));
    lfsr32(0x00000001,0x80200003,m,lfsr_a);
    lfsr32(0xDEADBEEF,0x80000063,m,lfsr_b);
    for(int i = 0;i < m;i++){
        int64_t res = (int64_t)(int)lfsr_a[i]*(int64_t)(int)lfsr_b[i];
        uint64_t resu = (uint64_t)lfsr_a[i]*(uint64_t)lfsr_b[i];
        fprintf(f,"\t%01X : %016lX\n",(unsigned int)(2*i),resu);
        fprintf(f,"\t%01X : %016lX\n",(unsigned int)(2*i+1),res);
    }
    fprintf(f,"END\n");
    fclose(f);
    return 0;
}