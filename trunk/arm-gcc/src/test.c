
void ARM32_SetBL ( unsigned int src, unsigned int dst )
{
	int value = dst - ( src + 8 );
	value = 0xFFFFFF & ( value >> 2 );
	value = 0xEB000000 | value;
	*(unsigned int *)src = value;
}

unsigned char *MemCpy ( unsigned char *dst, unsigned char *src, unsigned int len )
{
	while ( len-- )
		dst[len] = src[len];

	return dst;
}
