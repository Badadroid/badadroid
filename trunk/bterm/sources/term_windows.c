#if defined (WIN32) || defined(WIN64) || defined(_WIN32)|| defined(_WIN64)

#ifndef __TRIX_TERM_C__
#define __TRIX_TERM_C__

#include <windows.h>
HANDLE hCom;

#include <stdio.h>
#include <stdarg.h>

#include "defines.h"
#include "term.h"

static char portName[8];

unsigned int term_open ( char* devName )
{
	char portstr[32];

	if ( hCom )
	{
		printf ( "%s: COM port already open?\n", __FUNCTION__ );
		return RXE_FAIL;
	}

	sprintf ( portstr, "\\\\.\\%s", devName );
	hCom = CreateFile ( (LPCSTR)portstr,
	                    GENERIC_READ | GENERIC_WRITE,
	                    0,
	                    0,
	                    OPEN_EXISTING,
	                    0, //FILE_FLAG_OVERLAPPED,
	                    0 );

    if ( hCom == INVALID_HANDLE_VALUE )
    {
		printf ( "%s: could not open %s \n", __FUNCTION__, devName );
		hCom = NULL;
		portName = "";
		return RXE_FAIL;
    }

	printf ( "%s port opened with success\n", devName );
	portName = devName;

	return RXE_OK;
}

unsigned int term_close ( )
{
    if ( !hCom )
    {
        printf ( "%s: COM port was not open!\n", __FUNCTION__ );
        return RXE_FAIL;
    }

	CloseHandle ( hCom );

	printf ( "%s port closed with success\n", portName );

	portName = "";
	hCom = NULL;

	return RXE_OK;
}

/* device control settings */
unsigned int term_set_control ( unsigned int baud, unsigned char databits, unsigned char stopbits, unsigned char parity, unsigned char handshake )
{
    /*
        todo:
            - error checking
            - handshake
            - parity
            - stopbits
            - let the user configure timeouts ?
    */

    COMMCONFIG lpCC;
    COMMTIMEOUTS timeouts;

    if ( !hCom )
    {
        printf ( "%s: COM port was not open!\n", __FUNCTION__ );
        return RXE_FAIL;
    }

    GetCommTimeouts ( hCom, &timeouts );
    
	// TODO
	timeouts.ReadIntervalTimeout = 1;
    timeouts.ReadTotalTimeoutMultiplier = 0; 
    timeouts.ReadTotalTimeoutConstant = 3;
    timeouts.WriteTotalTimeoutMultiplier = 0;
    timeouts.WriteTotalTimeoutConstant = 3;

	if ( !SetCommTimeouts ( hCom, &timeouts ) )
    {
        printf ( "%s: setting timeouts didn't work!\n", __FUNCTION__ );
        return RXE_FAIL;
    }


	GetCommState ( hCom, &lpCC.dcb );

	lpCC.dcb.BaudRate = baud ? baud: CBR_115200;
    lpCC.dcb.ByteSize = databits;
    lpCC.dcb.StopBits = ONESTOPBIT;
    lpCC.dcb.Parity = NOPARITY;

    lpCC.dcb.fDtrControl = DTR_CONTROL_DISABLE;
    lpCC.dcb.fRtsControl = RTS_CONTROL_DISABLE;
    
	SetCommState ( hCom, &lpCC.dcb );

	return RXE_OK;
}

unsigned int term_send ( const unsigned char *data, const unsigned int bytes )
{
    unsigned int bytesWritten = 0;

    if ( !hCom )
    {
        printf ( "%s: COM port was not open!\n", __FUNCTION__ );
        return RXE_FAIL;
    }

    WriteFile ( hCom, data, bytes, (LPDWORD)&bytesWritten, 0 );

    if ( bytes != bytesWritten )
    {
        printf ( "%s: only sent %d bytes of %d\n", __FUNCTION__, bytesWritten, bytes );
        return RXE_FAIL;
    }

	return RXE_OK;
}

unsigned int term_receive ( unsigned char *dest, unsigned int dest_length, unsigned int *bytesRead )
{
	*bytesRead = 0;

    if ( !hCom )
    {
        printf ( "%s: COM port was not open!\n", __FUNCTION__ );
        return RXE_FAIL;
    }

	// Read data from the COM-port
	if ( !ReadFile ( hCom, dest, dest_length, (LPDWORD)bytesRead, 0 ) )
	{
		printf ( "%s: ReadFile returned error!\n", __FUNCTION__ );
		return RXE_FAIL;
	}
		
	return RXE_OK;
}

#endif /* __TERM_C__ */

#endif /* WIN32 */
