#ifndef __TERM_H__
#define __TERM_H__

unsigned int term_open ( char* devName );
unsigned int term_close ( );
unsigned int term_set_control ( unsigned int baud, unsigned char databits, unsigned char stopbits, unsigned char parity, unsigned char handshake );
unsigned int term_send ( const unsigned char *data, const unsigned int bytes );
unsigned int term_receive ( unsigned char *dest, unsigned int dest_length, unsigned int *bytesRead );

#endif /* __TERM_H__ */
