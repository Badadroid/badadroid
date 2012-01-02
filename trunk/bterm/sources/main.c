#ifndef __MAIN_C__
#define __MAIN_C__

#ifdef WIN32
#include <windows.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <string.h>

#include "defines.h"
#include "term.h"


static char dummy[256];

#define PROGRAM_TITLE           "bTerm"
#define PROGRAM_VERSION_MAJOR   0
#define PROGRAM_VERSION_MINOR   18

const char *DloadResponseType[] =
{
	"ACK",
	"NAK_INVALID_FCS",
	"NAK_INVALID_DEST",
	"NAK_INVALID_LEN",
	"NAK_EARLY_END",
	"NAK_TOO_LARGE",
	"NAK_INVALID_CMD",
	"NAK_FAILED",
	"NAK_WRONG_IID",
	"NAK_BAD_VPP",
	"NAK_OP_NOT_PERMITTED",
	"NAK_INVALID_ADDR",
	"NAK_VERIFY_FAILED",
	"NAK_NO_SEC_CODE",
	"NAK_BAD_SEC_CODE",
	"NAK_FLASH_ERROR",
	"NAK_INVALID_CONTENT",
	""
};

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
	CMD_CODE_RUN           = 0x03,
	CMD_CONN_CHECK         = 0x04,
	CMD_LOAD_BIN           = 0x05,
	CMD_BRANCH             = 0x06
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
	long start, end;
//	start = GetTickCount();
	term_receive ( packet, 0x4200, &length );	
//	end = GetTickCount();
	
//	printf("term_receive time: %dms\n", (end-start));


	if ( 6 == length && 2 == packet[2] )
		return 0xFFFFFFFF;	

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

unsigned int check_connection ( void )
{
	unsigned char buf[] = { CMD_CONN_CHECK };

	send_packet ( CMD_CUSTOM, buf, 1 );

	if ( 0xFFFFFFFF == get_packet ( CMD_CUSTOM, buf ) )
		return RXE_OK;

	return RXE_FAIL;
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

unsigned char* devSearch ( void )
{

	char* ret = (char*)malloc(32);
	int found = 0;
#if defined(WIN32) || defined(WIN64)
	HKEY hKey;
	unsigned char pValue[255];
	unsigned char pData[255];
	unsigned int cValues, cValue, cData, retCode;

	ret[0]=0;
	RegOpenKeyExA ( HKEY_LOCAL_MACHINE, "HARDWARE\\DEVICEMAP\\SERIALCOMM\\", 0, KEY_READ, &hKey );
	RegQueryInfoKeyA ( hKey, NULL, NULL, NULL, NULL, NULL, NULL, (LPDWORD)&cValues, NULL, NULL, NULL, NULL );

	while ( !found && cValues-- )
	{
		cData = cValue = 255;
		retCode = RegEnumValueA ( hKey, cValues, (LPSTR)pValue, (LPDWORD)&cValue, NULL, NULL, (LPBYTE)pData, (LPDWORD)&cData );

		if ( retCode == ERROR_SUCCESS )
			if ( !strncmp ( "\\Device\\sscemdm", (const char *)pValue, 15 ) ||
			     !strncmp ( "\\Device\\ssudmdm", (const char *)pValue, 15 ) ) // SAMSUNG Mobile Modem
				if ( !strncmp ( "COM", (const char *)pData, 3 ) )
				{
					found = 1;
					strcpy(ret, pData);
					//port_num = atoi ( (const char *)( pData + 3 ) )
				}
	}


	RegCloseKey ( hKey );
#endif
#ifdef __linux__
	sprintf(ret,"ttyACM0"); //hardcoded for now
#endif
	return ret;
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
		     " open the COM port\n"
	         " open\n\n"
			 " close the COM port\n"
	         " close\n\n"
			 " check the connection\n"
	         " check\n\n"
			 " dump NAND area\n"
	         " dump    <address> <length>\n\n"
			 " dump RAM area\n"
			 " dumpram <address> <length>\n\n"
			 " execute the code from file\n"
			 " run  <path_to_file>\n\n"			 
			 " load binary into memory under specified address and store its size\n"
			 " loadbin  <path> <addr> <optional|sizeaddr>\n\n"				 
			 " branch target without link to specific address\n"
			 " branch <addr>\n\n"
			 " terminate program\n"
	         " exit\n\n" 
			 " open the COM port for upload\n"
	         " uopen\n\n" 
			 " upload mode operation\n"
	         " upload    <address_from> <address_to>\n\n"
            
            );

	while ( printf ( "\n>" ) && gets ( cmd ) && cmd[0] )
	{
		if ( !strncmp ( "open", cmd , 4) )
		{
			if ( RXE_OK  == term_open ( devSearch ( ) ))       //CMD_CONN_OPEN
			{
				term_set_control ( 1382400, 8, 1, 0, 0 );
				term_send ( "AT+FUS?\r\n", 9 );	
				check_connection ( );
				term_receive ( buf, 0x4200, &bytesRead );
			}
		}
		if ( !strncmp ( "uopen", cmd , 5) )
		{
			if ( RXE_OK  == term_open ( devSearch ( ) ))       //CMD_CONN_OPEN
			{
				term_set_control ( 1382400, 8, 1, 0, 0 );
				term_receive ( buf, 0x4200, &bytesRead );
			}
		}
		else if ( !strncmp ( "close", cmd , 5) )
		{
			term_close ( );
			check_connection ( );
		}
		else if ( !strncmp ( "exit", cmd, 4) )
		{
			term_close ( );
			term_receive ( buf, 0x4200, &bytesRead );
			Sleep(1000);
			break;
		}
		else if ( !strncmp ( "check", cmd , 5) )
		{
			if ( RXE_OK == check_connection ( ) )
				printf ( "Phone response OK\n" );
			else
				printf ( "Phone response FAIL\n" );
		}
		else if ( !strncmp ( "dump ", cmd, 5 ) || !strncmp ( "dumpram ", cmd, 8 ) )
		{
			unsigned int address, length, packet_len, total_length, dumpram = 0;

			if ( !strncmp ( "dumpram ", cmd, 8 ) ) 
			{
				dumpram = 1;
			}
				sscanf ( cmd, "%s %X %X", &dummy, &address, &length );


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
						unsigned int retries = 3;

						if ( length > 0x2000 )
							packet_len = 0x2000;
						else
							packet_len = length;

						while ( retries-- )
						{
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
								Sleep ( 300 );
								if ( RXE_OK == check_connection ( ) ||  RXE_OK == check_connection ( ) ||  RXE_OK == check_connection ( ) ) //ugly hax to improve dump stability
								{
									printf ( "\nError receiving packet (%d bytes at 0x%08X). Received %d bytes only.", packet_len, address, bytesRead );
									printf ( "\nRetrying(%d/3)...\n", 2 - retries );									
									Sleep ( 300 );
								}
								else
								{
									printf ( "\nConnection failed!\n" );
									retries = 0;
								}

								if ( 0 == retries )
								{
									printf ( "\nAbandoning dump with total received 0x%08X bytes.", total_length - length );
									length = 0;
									break;
								}
							}
							else
							{
								float percent;

								fwrite ( buf, 1, bytesRead, fh );

								length -= packet_len;
								address += packet_len;

								percent = (float)100 * ( total_length - length ) / total_length;
								printf ( "\b\b\b%02d%%", (unsigned int)percent );
								break;
							}
						}
					}
					while ( length > 0 );

					fclose ( fh );
				}
				else
					printf ( "Can't open output file (%s)!", outname );
			}
		}
		else if ( !strncmp ( "upload ", cmd, 7 )  )
		{
			unsigned int address1, address2, packet_len, total_length;

			sscanf ( cmd, "%s %X %X", &dummy, &address1, &address2 );


			if ( address2 - address1 > 0 )
			{
				total_length = address2 - address1;
				
				sprintf ( outname, "upload_0x%08X.0x%08X.bin", address1, address2 );
				
				if ( fh = fopen ( outname, "wb" ) )
				{
//					printf ( "dumping %s at 0x%08X: 00%%", print_bytes ( length ), address );
					term_send ( "PrEaMbLe", 9 );
					term_receive ( buf, 0x4200, &bytesRead );
					sprintf ( outname, "%08X", address1 );
					term_send ( (const unsigned char*)outname, 9 );
					term_receive ( buf, 0x4200, &bytesRead );
					sprintf ( outname, "%08X", address2 );
					term_send ( (const unsigned char*)outname, 9 );
					term_receive ( buf, 0x4200, &bytesRead );
					term_send ( "DaTaXfEr", 9 );
					term_receive ( buf, 0x4200, &bytesRead );
										
					fwrite ( buf, 1, bytesRead, fh );

					fclose ( fh );
				}
				else
					printf ( "Can't open output file (%s)!", outname );
			}
		}
		else if ( !strncmp ( "run ", cmd, 4 ) )
		{
			char fname[48];
			sscanf(cmd, "%s %s", &dummy, &fname);
			if ( fh = fopen (fname, "rb" ) )
			{
				unsigned int code_length;
				code_length = fread ( buf + 3, 1, (0x2000), fh );
				fclose ( fh );

				if ( code_length )
				{
					SET_BYTE ( buf, 0, CMD_CODE_RUN );
					SET_HALF ( buf, 1, code_length );

					send_packet ( CMD_CUSTOM, buf, code_length + 3 );

					if ( RXE_OK == check_connection ( ) )
						printf ( "OK\n" );
					else
						printf ( "FAIL\n" );
				}
			}
			else
				printf ( "Can't open input file (%s)!", fname );
		}
		else if ( !strncmp ( "branch ", cmd, 7 ) )
		{
			unsigned int addr;
			sscanf(cmd, "%s %X", &dummy, &addr);

			SET_BYTE ( buf, 0, CMD_BRANCH );
			SET_WORD ( buf, 1, addr );

			send_packet ( CMD_CUSTOM, buf, 5 );

			if ( RXE_OK == check_connection ( ) )
				printf ( "OK\n" );
			else
				printf ( "FAIL (probably it isnt fail at all)\n" );
		}
		else if ( !strncmp ( "loadbin ", cmd, 8 ) )
		{
			
			char fname[48];
			unsigned int target_addr, size_addr;
			
			sscanf(cmd, "%s %s %X %X", &dummy, &fname, &target_addr, &size_addr);
			if(target_addr == 0)
			{
				printf("Zomg, specify address please!\n");
				continue;
			}
			if ( fh = fopen (fname, "rb" ) )
			{

				unsigned int code_length, f_size, pack_n, percent, total;
				check_connection ( );
				fseek(fh, 0, SEEK_END);
				f_size = ftell(fh);
				pack_n = (f_size+0x1EFF)/0x1F00;
				total = pack_n;
				rewind(fh);
				
				printf("loading 0x%X bytes from %s under 0x%08X\n", f_size, &fname, target_addr);
				printf("splitting into %d packets\n", pack_n);

				while(pack_n--)
				{
					code_length = fread ( buf + 7, 1, 0x1F00, fh );
					if ( code_length )
					{
						SET_BYTE ( buf, 0, CMD_LOAD_BIN );
						SET_HALF ( buf, 1, code_length );
						SET_WORD ( buf, 3, target_addr);

						send_packet ( CMD_CUSTOM, buf, code_length + 7 );	

						target_addr += 0x1F00;
						percent = (float)100 * ( total-pack_n ) / total;
						printf ( "\b\b\b%02d%%", (unsigned int)percent );
#ifdef __linux__
//on windows it slows down transfer, on linux it makes connection stable - otherwise data flows too fast
						check_connection ( );
#endif
					}
					else
					{
						printf ( "fread fail, this should not happen, wtf?!\n" );
						break;
					}
				}

				printf("\nDONE!\n");

				if(size_addr)
				{					
				
					printf("storing 0x%X under 0x%08X\n", f_size, size_addr);
					SET_BYTE ( buf, 0, CMD_LOAD_BIN );
					SET_HALF ( buf, 1, 4 );
					SET_WORD ( buf, 3, size_addr);
					SET_WORD ( buf, 7, f_size);

					send_packet ( CMD_CUSTOM, buf, 4 + 7 );
				}
				
				fclose ( fh );

				if ( RXE_OK == check_connection ( ) )
					printf ( "OK\n" );
				else
					printf ( "FAIL\n" );

			}
			else
				printf ( "Can't open input file (%s)!", fname );
		}
		else
			printf ( "Unknown command!\n" );
	}

	return RXE_OK;
}

#endif /* __MAIN_C__ */
