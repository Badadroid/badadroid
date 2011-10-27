#ifndef __MAIN_C__
#define __MAIN_C__

#ifdef WIN32
#include <windows.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "defines.h"
#include "term.h"


#define PROGRAM_TITLE           "bTerm"
#define PROGRAM_VERSION_MAJOR   0
#define PROGRAM_VERSION_MINOR   14


typedef enum DloadCMD
{
	CMD_USB_DUMP            = 0x23,
	CMD_USB_VERIFY          = 0x24,
	CMD_USB_DEBUG           = 0x25,
	CMD_USB_FULLDOWNLOAD    = 0x50,
	CMD_USB_DOWNLOAD_UNLOCK = 0x60,
	CMD_USB_INFO            = 0x70,
	CMD_USB_SET_DBG_LVL     = 0x71,
	CMD_USB_SECURITY        = 0x80,
	CMD_USB_RESET           = 0x90,
	CMD_USB_UNLOCK          = 0xA0,
	CMD_USB_COPY            = 0xB0,
	CMD_USB_CSC_WRITE       = 0xB2,
	CMD_USB_SHPAPP_WRITE    = 0xB3,
	CMD_USB_PFS_WRITE       = 0xB4,
	CMD_USB_LOCK            = 0xC0,
	CMD_USB_VER_CHECK       = 0xD0,
	CMD_USB_READ            = 0xDA,
	CMD_USB_WRITE           = 0xDD,
	CMD_USB_ERASE           = 0xEE,
	CMD_USB_ERASE_MC        = 0xEF,
	CMD_USB_FORMAT          = 0xF0,
	
	CMD_CUSTOM              = 0xDE
} DloadCMD;

typedef enum DloadCMDCustom
{
	CMD_READ_NAND          = 0x01,
	CMD_READ_RAM           = 0x02,
	CMD_CODE_RUN           = 0x03
} DloadCMDCustom;


unsigned short calc_crc16 ( unsigned short crc, const unsigned char *data, unsigned int length )
{
    const static unsigned short crc_tab[256] =
	{
		0x0000, 0x1189, 0x2312, 0x329B, 0x4624, 0x57AD, 0x6536, 0x74BF,
		0x8C48, 0x9DC1, 0xAF5A, 0xBED3, 0xCA6C, 0xDBE5, 0xE97E, 0xF8F7,
		0x1081, 0x0108, 0x3393, 0x221A, 0x56A5, 0x472C, 0x75B7, 0x643E,
		0x9CC9, 0x8D40, 0xBFDB, 0xAE52, 0xDAED, 0xCB64, 0xF9FF, 0xE876,
		0x2102, 0x308B, 0x0210, 0x1399, 0x6726, 0x76AF, 0x4434, 0x55BD,
		0xAD4A, 0xBCC3, 0x8E58, 0x9FD1, 0xEB6E, 0xFAE7, 0xC87C, 0xD9F5,
		0x3183, 0x200A, 0x1291, 0x0318, 0x77A7, 0x662E, 0x54B5, 0x453C,
		0xBDCB, 0xAC42, 0x9ED9, 0x8F50, 0xFBEF, 0xEA66, 0xD8FD, 0xC974,
		0x4204, 0x538D, 0x6116, 0x709F, 0x0420, 0x15A9, 0x2732, 0x36BB,
		0xCE4C, 0xDFC5, 0xED5E, 0xFCD7, 0x8868, 0x99E1, 0xAB7A, 0xBAF3,
		0x5285, 0x430C, 0x7197, 0x601E, 0x14A1, 0x0528, 0x37B3, 0x263A,
		0xDECD, 0xCF44, 0xFDDF, 0xEC56, 0x98E9, 0x8960, 0xBBFB, 0xAA72,
		0x6306, 0x728F, 0x4014, 0x519D, 0x2522, 0x34AB, 0x0630, 0x17B9,
		0xEF4E, 0xFEC7, 0xCC5C, 0xDDD5, 0xA96A, 0xB8E3, 0x8A78, 0x9BF1,
		0x7387, 0x620E, 0x5095, 0x411C, 0x35A3, 0x242A, 0x16B1, 0x0738,
		0xFFCF, 0xEE46, 0xDCDD, 0xCD54, 0xB9EB, 0xA862, 0x9AF9, 0x8B70,
		0x8408, 0x9581, 0xA71A, 0xB693, 0xC22C, 0xD3A5, 0xE13E, 0xF0B7,
		0x0840, 0x19C9, 0x2B52, 0x3ADB, 0x4E64, 0x5FED, 0x6D76, 0x7CFF,
		0x9489, 0x8500, 0xB79B, 0xA612, 0xD2AD, 0xC324, 0xF1BF, 0xE036,
		0x18C1, 0x0948, 0x3BD3, 0x2A5A, 0x5EE5, 0x4F6C, 0x7DF7, 0x6C7E,
		0xA50A, 0xB483, 0x8618, 0x9791, 0xE32E, 0xF2A7, 0xC03C, 0xD1B5,
		0x2942, 0x38CB, 0x0A50, 0x1BD9, 0x6F66, 0x7EEF, 0x4C74, 0x5DFD,
		0xB58B, 0xA402, 0x9699, 0x8710, 0xF3AF, 0xE226, 0xD0BD, 0xC134,
		0x39C3, 0x284A, 0x1AD1, 0x0B58, 0x7FE7, 0x6E6E, 0x5CF5, 0x4D7C,
		0xC60C, 0xD785, 0xE51E, 0xF497, 0x8028, 0x91A1, 0xA33A, 0xB2B3,
		0x4A44, 0x5BCD, 0x6956, 0x78DF, 0x0C60, 0x1DE9, 0x2F72, 0x3EFB,
		0xD68D, 0xC704, 0xF59F, 0xE416, 0x90A9, 0x8120, 0xB3BB, 0xA232,
		0x5AC5, 0x4B4C, 0x79D7, 0x685E, 0x1CE1, 0x0D68, 0x3FF3, 0x2E7A,
		0xE70E, 0xF687, 0xC41C, 0xD595, 0xA12A, 0xB0A3, 0x8238, 0x93B1,
		0x6B46, 0x7ACF, 0x4854, 0x59DD, 0x2D62, 0x3CEB, 0x0E70, 0x1FF9,
		0xF78F, 0xE606, 0xD49D, 0xC514, 0xB1AB, 0xA022, 0x92B9, 0x8330,
		0x7BC7, 0x6A4E, 0x58D5, 0x495C, 0x3DE3, 0x2C6A, 0x1EF1, 0x0F78
    };

    while ( length-- )
	{
        crc = crc_tab [ ( *data ^ crc ) & 0xFF ] ^ ( crc >> 8 );
        data++;
    }

    return crc;
}

unsigned int send_packet ( DloadCMD type, const unsigned char *data, unsigned int length )
{
	unsigned char packet[0x4200];

	static unsigned int parity = 0;
	unsigned int i = 0, pos = 0;
	unsigned short crc = 0xFFFF;

	if ( length > 0x4100 )
		return RXE_FAIL;
	
	parity = ( parity + 1 ) & 3;

	packet[pos++] = 0x7E;
	packet[pos++] = parity;
	packet[pos++] = type;

	crc = calc_crc16 ( crc, packet + 2, 1 );
	crc = calc_crc16 ( crc, data, length ) ^ 0xFFFF;

	while ( i < length )
	{
		if ( 0x7D == data[i] || 0x7E == data[i] )
		{
			packet[pos++] = 0x7D;
			packet[pos++] = data[i] ^ 0x20;
		}
		else
			packet[pos++] = data[i];

		if ( pos >= 0x4100 )
			break;

		i++;
	}
	
	i = crc & 0xFF;
	if ( 0x7D == i || 0x7E == i )
	{
		packet[pos++] = 0x7D;
		packet[pos++] = i ^ 0x20;
	}
	else
		packet[pos++] = i;

	i = crc >> 8;
	if ( 0x7D == i || 0x7E == i )
	{
		packet[pos++] = 0x7D;
		packet[pos++] = i ^ 0x20;
	}
	else
		packet[pos++] = i;

	packet[pos++] = 0x7E;

	return term_send ( packet, pos );
}

unsigned int get_packet ( DloadCMD type, unsigned char *buffer )
{
	unsigned char packet[0x4200];
	unsigned short crc = 0xFFFF;
	unsigned int byte, packet_ok = 0, mode = 0, i = 0, pos = 0, length;

	term_receive ( packet, 0x4200, &length );
	
	while ( i < length )
	{
		byte = packet[i++];

		switch ( mode )
		{
			case 0:
				if ( 0x7E == byte )
					mode = 1;
				// CHECK SIZE
			break;

			case 1:
				if ( 0x7E == byte )
				{
					mode = 0;
				}
				else
				{
					i++; // skip first byte
					pos = 0;
					crc = 0xFFFF;
					packet_ok = 0;
					mode = 2;
				}
				// CHECK
			break;

			case 2:
				if ( 0x7E == byte )
				{
					if ( i >= 3 )
					{
						if ( 0xF0B8 == crc )
						{
							packet_ok = 1;
							i = 0;
							mode = 0;
						}
						else
						{
							// "NAK_INVALID_FCS crc=%d\n"	
							// DloadResponse ( 1, 0 );
							// while ( 1 );
						}
					}
					else
					{
						// "NAK_EARLY_END len=%d\n"
						// DloadResponse ( 4, 0 );
						// while ( 1 );
					}
		
				}
				else if ( 0x7D == byte )
				{
					mode = 3;
				}
				else
				{
					buffer[pos++] = byte;
					// crc
				}
				// CHECK SIZE
			break;

			case 3:
			{
				mode = 2;
				buffer[pos++] = byte ^ 0x20;
				// crc
				if ( pos >= 0x4100 )
				{
					// "NAK_TOO_LARGE len=%d %d\n"
					// DloadResponse ( 5, 0 );
					// while ( 1 ) ;
				}
			}
			break;

			default:
				mode = 0;
		}
	}

	if ( pos > 2 )
		return pos - 2;
	else
		return 0;
}

const char *print_bytes ( unsigned int bytes )
{
	static char print_bytes[0x100];
	
	if ( bytes < 1024 )
		sprintf ( print_bytes, "%d  B", bytes );
	else
	{
		float fbytes = (float)bytes / 1024;

		if ( fbytes < 1024 )
			sprintf ( print_bytes, "%.1f KB", fbytes );
		else if ( fbytes < 1024 * 1024 )
			sprintf ( print_bytes, "%.1f MB", fbytes / 1024 );
		else
			sprintf ( print_bytes, "%.1f GB", fbytes / ( 1024 * 1024 ) );
	}

	return (const char *)print_bytes;
}

unsigned int COMSearch ( void )
{
	HKEY hKey;
	unsigned char pValue[255];
	unsigned char pData[255];
	unsigned int cValues, cValue, cData, retCode;
	unsigned int port_num = 0;

	RegOpenKeyExA ( HKEY_LOCAL_MACHINE, "HARDWARE\\DEVICEMAP\\SERIALCOMM\\", 0, KEY_READ, &hKey );
	RegQueryInfoKeyA ( hKey, NULL, NULL, NULL, NULL, NULL, NULL, (LPDWORD)&cValues, NULL, NULL, NULL, NULL );

	while ( !port_num && cValues-- )
	{
		cData = cValue = 255;
		retCode = RegEnumValueA ( hKey, cValues, (LPSTR)pValue, (LPDWORD)&cValue, NULL, NULL, (LPBYTE)pData, (LPDWORD)&cData );

		if ( retCode == ERROR_SUCCESS )
			if ( !strncmp ( "\\Device\\sscemdm", (const char *)pValue, 15 ) ||
			     !strncmp ( "\\Device\\ssudmdm", (const char *)pValue, 15 ) ) // SAMSUNG Mobile Modem
				if ( !strncmp ( "COM", (const char *)pData, 3 ) )
					port_num = atoi ( (const char *)( pData + 3 ) );
	}

	RegCloseKey ( hKey );

	return port_num;
}

int main ( int argc, char **argv )
{
	unsigned char buf[0x4200];
	char cmd[256];
	char outname[256];
	FILE *fh;
	unsigned int bytesRead;


	printf ( "\n%s v%d.%02d\n\n", PROGRAM_TITLE, PROGRAM_VERSION_MAJOR, PROGRAM_VERSION_MINOR );
	printf ( "Enter command you want to send or press enter to exit\n" );
	printf ( "Available commands:\n"
	         " open                       - open the COM port\n"
	         " close                      - close the COM port\n"
	         " dump    <address> <length> - dump NAND area\n"
			 " dumpram <address> <length> - dump RAM area\n"
			 " run  <path_to_file>        - execute the code from file\n"
	         " exit                       - terminate program\n" );

	while ( printf ( "\n>" ) && gets ( cmd ) && cmd[0] )
	{
		if ( !strcmp ( "open", cmd ) )
		{
			if ( term_open ( COMSearch ( ) ) == RXE_OK )
			{
				term_set_control ( 1382400, 8, 1, 0, 0 );
				term_send ( "AT+FUS?\r\n", 9 );
				term_receive ( buf, 0x4200, &bytesRead );
			}
		}
		else if ( !strcmp ( "close", cmd ) )
		{
			term_close ( );
		}
		else if ( !strcmp ( "exit", cmd ) )
		{
			term_close ( );
			break;
		}
		else if ( !strncmp ( "dump ", cmd, 5 ) || !strncmp ( "dumpram ", cmd, 8 ) )
		{
			unsigned int address, length, packet_len, total_length, dumpram, retries, rcvd = 0;

			if ( !strncmp ( "dumpram ", cmd, 8 ) ) 
			{
				dumpram = 1;
				sscanf ( cmd + 8, "%X %X", &address, &length );
			}
			else
				sscanf ( cmd + 5, "%X %X", &address, &length );

			if ( length > 0 )
			{
				total_length = length;
				
				if ( dumpram )
					sprintf ( outname, "dump_ram_0x%08X.0x%08X.bin", address, length );
				else
					sprintf ( outname, "dump_nand_0x%08X.0x%08X.bin", address, length );
				
				if ( fh = fopen ( outname, "wb" ) )
				{
					printf ( "dumping %s at 0x%08X: 00%%", print_bytes ( length ), address );
					
					do
					{
						if ( length > 0x2000 )
							packet_len = 0x2000;
						else
							packet_len = length;
						retries = 0;
retry:					
						if ( dumpram )
							SET_BYTE ( buf, 0, CMD_READ_RAM );
						else
							SET_BYTE ( buf, 0, CMD_READ_NAND );

						SET_WORD ( buf, 1, address );
						SET_HALF ( buf, 5, packet_len );

						send_packet ( CMD_CUSTOM, buf, 7 );
						bytesRead = get_packet ( CMD_CUSTOM, buf );

						if ( bytesRead < packet_len )
						{
							printf ( "\nError receiving packet (%d bytes at 0x%08X). Received %d bytes only.", packet_len, address, bytesRead );
							printf("\nRetrycount: %d/3", retries);
							if(++retries <= 3)
							{
								printf("\nRetrying!");
								Sleep(300);
								goto retry;
							}
							else
							{								
								printf("\nAbandoning dump with total received 0x%08X bytes.", rcvd);
								length = 0;
							}
						}
						else
						{
							float percent;
							
							fwrite ( buf, 1, bytesRead, fh );

							length -= packet_len;
							address += packet_len;
							rcvd += packet_len;
							
							percent = (float)100 * ( total_length - length ) / total_length;
							printf ( "\b\b\b%02d%%", (unsigned int)percent );
						}
					}
					while ( length > 0 );

					fclose ( fh );
				}
				else
					printf ( "Can't open output file (%s)!", outname );
			}
		}
		else if ( !strncmp ( "run ", cmd, 4 ) )
		{
			if ( fh = fopen ( cmd + 4, "rb" ) )
			{
				unsigned int code_length;
				code_length = fread ( buf + 3, 1, 0x2000, fh );
				fclose ( fh );

				if ( code_length )
				{
					SET_BYTE ( buf, 0, CMD_CODE_RUN );
					SET_HALF ( buf, 1, code_length );

					send_packet ( CMD_CUSTOM, buf, code_length + 3 );
					bytesRead = get_packet ( CMD_CUSTOM, buf );
					printf ( "OK - %d\n", bytesRead );
				}
			}
			else
				printf ( "Can't open input file (%s)!", outname );
		}
		else
			printf ( "Unknown command!\n" );
	}

	return RXE_OK;
}

#endif /* __MAIN_C__ */
