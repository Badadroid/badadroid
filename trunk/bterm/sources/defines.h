#ifndef __DEFINES_H__
#define __DEFINES_H__

#ifdef __cplusplus
extern "C" {
#endif

#define RXE_OK                          0x00000000
#define RXE_FAIL                        0xFFFFFFFF

#define R( x )                          { if ( x != RXE_OK ) return RXE_FAIL; }

#define _UINT(x)                        ( (unsigned int)(x) )
#define ABS(x)                          ( ( (x) < 0) ? -(x) : (x) )
#define SWAP(x,y)                       ( ( _UINT(x) ^ _UINT(y) ) && ( _UINT(y) ^= _UINT(x) ^= _UINT(y), _UINT(x) ^= _UINT(y) ) )
#define ALIGN2(x)                       ( ( ( x ) + 1 ) & ~1 )
#define ALIGN4(x)                       ( ( ( x ) + 3 ) & ~3 )
#define ALIGN8(x)                       ( ( ( x ) + 7 ) & ~7 )
#define ALIGN16(x)                      ( ( ( x ) + 15 ) & ~15 )
#define ALIGN_WORD(x)                   ( ( ( x ) + 3 ) & ~3 )
#define ALIGN_HALF(x)                   ( ( ( x ) + 1 ) & ~1 )
#define ALIGN_BY(x,y)                   ( ( ( x ) % ( y ) ) ? ( ( x ) + ( y ) - ( x ) % ( y ) ) : ( x ) )
#define MAKE_ID( s )                    ( (unsigned int)( ( s[0] << 24 ) | ( s[1] << 16 ) | ( s[2] << 8 ) | ( s[3] ) ) )
#define MIN(a,b)                        ( a ) < ( b ) ? ( a ) : ( b ) )
#define MAX(a,b)                        ( ( a ) > ( b ) ? ( a ) : ( b ) )

#define CHECK_AND_FREE( s )             if ( x ) { free ( x ); x = NULL; }
#define STR_FREE( s )                   do { CHECK_AND_FREE ( ( s )->buffer ); ( s )->length = 0; ( s )->allocated = 0; } while ( 0 )

#define GET_BYTE( data, pos )           ( ( (unsigned char *)( data ) )[pos] )
#define GET_HALF( data, pos )           ( ( GET_BYTE ( data, ( pos + 1 ) ) << 8 ) | GET_BYTE ( data, ( pos ) ) )
#define GET_WORD( data, pos )           ( ( GET_HALF ( data, ( pos + 2 ) ) << 16 ) | GET_HALF ( data, ( pos ) ) )

#define SET_BYTE( data, pos, val )      do { ( (unsigned char *)( data ) )[pos] = val; } while ( 0 )
#define SET_HALF( data, pos, val )      do { SET_BYTE ( data, ( pos ) + 1, ( ( val ) >> 8 ) & 0xFF ); SET_BYTE ( data, ( pos ), ( val ) & 0xFF ); } while ( 0 )
#define SET_WORD( data, pos, val )      do { SET_HALF ( data, ( pos ) + 2, ( ( val ) >> 16 ) & 0xFFFF ); SET_HALF ( data, ( pos ), ( val ) & 0xFFFF ); } while ( 0 )


typedef struct // data array
{
	unsigned char *buffer;
	unsigned int length;
	unsigned int allocated;
} char_t;


typedef struct
{
	const char *name;
	unsigned int type;
} cmd_t;

#ifdef __cplusplus
}
#endif

#endif /* __DEFINES_H__ */
