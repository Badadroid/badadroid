#ifdef __linux__

#ifndef __TRIX_TERM_C__
#define __TRIX_TERM_C__


#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/shm.h>
#include <termios.h>
#include <fcntl.h>  
#include <stdbool.h>

#include "defines.h"
#include "term.h"

static int fd = -1;



unsigned int term_open ( char* devName )
{

	if ( fd != -1)
	{
		printf ( "%s: port already open?\n", __FUNCTION__ );
		return RXE_FAIL;
	}

	char devPath[32];

	sprintf ( devPath, "/dev/%s", devName );
	fd = open(devPath, O_RDWR | O_NOCTTY);

	if (fd == -1)
	{
		printf ( "%s: could not open %s\n", __FUNCTION__, devPath );
		return RXE_FAIL;
	}

	printf ( "%s opened with success\n", devPath );

	return RXE_OK;
}

unsigned int term_close ( )
{
	if ( fd == -1 )
	{
		printf ( "%s: dev was not open!\n", __FUNCTION__ );
		return RXE_FAIL;
	}

	close ( fd );

	printf ( "dev closed with success\n" );

	fd = -1;

	return RXE_OK;
}

/* device control settings */
unsigned int term_set_control ( unsigned int baud, unsigned char databits, unsigned char stopbits, unsigned char parity, unsigned char handshake )
{
	struct termios options;      // Structure with the device's options
	if ( fd == -1 )
	{
		printf ( "%s: tty port was not open!\n", __FUNCTION__ );
		return RXE_FAIL;
	}
	tcgetattr(fd, &options);
    bzero(&options, sizeof(options));					// Clear all the options
    speed_t         Speed;
    switch (baud)                                                      // Set the speed (Bauds)
    {
    case 110  :     Speed=B110; break;
    case 300  :     Speed=B300; break;
    case 600  :     Speed=B600; break;
    case 1200 :     Speed=B1200; break;
    case 2400 :     Speed=B2400; break;
    case 4800 :     Speed=B4800; break;
    case 9600 :     Speed=B9600; break;
    case 19200 :    Speed=B19200; break;
    case 38400 :    Speed=B38400; break;
    case 57600 :    Speed=B57600; break;
    case 115200 :   Speed=B115200; break;
    default :  Speed=B115200;
	}

    cfsetispeed(&options, Speed);
    cfsetospeed(&options, Speed);

    options.c_cflag |= ( CLOCAL | CREAD |  CS8);
    options.c_iflag |= ( IGNPAR | IGNBRK );
    options.c_cc[VTIME]=1; //0 to no timeout, 2 is 1/10 sec timeout
    options.c_cc[VMIN]=0; //nonblockingread (blocking in fact if there's timeout)
    tcsetattr(fd, TCSANOW, &options);					

	return RXE_OK;
}

unsigned int term_send ( const unsigned char *data, const unsigned int bytes )
{
    unsigned int bytesWritten = 0;

    if ( fd == -1 )
    {
        printf ( "%s: dev port was not open!\n", __FUNCTION__ );
        return RXE_FAIL;
    }

    bytesWritten = write(fd, data, bytes);

    if ( bytes != bytesWritten )
    {
        printf ( "%s: only sent %d bytes of %d\n", __FUNCTION__, bytesWritten, bytes );
        return RXE_FAIL;
    }

	return RXE_OK;
}
/*
unsigned int term_receive ( unsigned char *dest, unsigned int dest_length, unsigned int *bytesRead )
{
	*bytesRead = 0;

    if ( fd == -1 )
    {
        printf ( "%s: COM port was not open!\n", __FUNCTION__ );
        return RXE_FAIL;
    }
           
    while (Timer.ElapsedTime_ms() < read_timeout)        
    {
        unsigned char* ptr=(unsigned char*)(dest+*bytesRead);         
        int ret = read(fd, (void*)ptr, dest_length - *bytesRead);              
        if (ret==-1) 
		return RXE_FAIL;                                       
        if (ret>0) {                                                    
		*bytesRead += ret;                                            
		if (bytesRead >= dest_length)                                 
		return RXE_OK;
        }
    }
    return RXE_OK;  
}*/


unsigned int term_receive_byte(unsigned char* dest)
{
	if(fd == -1)
	{
		printf ( "%s: tty was not open!\n", __FUNCTION__ );
		return RXE_FAIL;
	}
	int ret;
	for(;;){
		ret = read(fd,dest,1);

		if(ret == 1)
			return RXE_OK;
		else if(ret == -1)
{
printf("error: %s\n", strerror(errno));
			return RXE_FAIL;
}
		else if(ret == 0)
		{
			return RXE_FAIL; //timeout
		}
	}
}

unsigned int term_receive ( unsigned char *dest, unsigned int dest_length, unsigned int *bytesRead )
{
	unsigned char byte;
	*bytesRead = 0;
	bool escape = true;
	while(term_receive_byte(&byte) != RXE_FAIL)
	{
		dest[*bytesRead] = byte;
		(*bytesRead)++;
		if(!escape)
		{		
			if(byte == 0x7D)
			{
				escape = true;
				continue;
			}
			else if(byte == 0x7E)
				return RXE_OK;	
		}
		escape = false;		
	}
	return RXE_FAIL;
}


#endif /* __TERM_C__ */

#endif
