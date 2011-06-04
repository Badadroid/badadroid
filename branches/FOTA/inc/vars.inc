;default vars and strings to be used by functions, to avoid mess in main file

macro DEFAULT_VARIABLES
{
    fota_x		dw x_pos@disp_FOTA_Printf_1

    output_switch	dw 0 ; 0=none 1=FOTA, 2=UART

    ;delays are given in nanoseconds
    v_delay_100ms	dw 100000
    v_delay_800ms	dw 800000
    v_delay		dw 4000000
}
macro DEFAULT_STRINGS_ADDR
{
    s_fmt_a		dw s_fmt
    s_dir_a		dw s_dir
    s_debug_fmt_hex_a	dw s_debug_fmt_hex
    s_debug_fmt_int_a	dw s_debug_fmt_int
    s_notfound_a	dw s_notfound
    s_downloadmode_a	dw s_downloadmode
    s_memdump_a 	dw s_memdump
    s_done_a		dw s_done
    s_written_a 	dw s_written
    s_fileload_a	dw s_fileload
    s_filesize_a	dw s_filesize
    s_read_a		dw s_read
    s_error_a		dw s_error
    s_fotaoutput_a	dw s_fotaoutput
    s_uartoutput_a	dw s_uartoutput
    s_uart_newline_a	dw s_uart_newline
    s_loadfile_error_a	dw s_loadfile_error
    s_memcpy_a		dw s_memcpy
    s_dumpmem_error_a	dw s_dumpmem_error
}
macro DEFAULT_STRINGS
{
    s_fotaoutput		    db ' FOTA OUTPUT ENABLED',0
    s_uartoutput		    db ' UART OUTPUT ENABLED',0
    s_downloadmode		    db ' ENTERING DOWNLOAD MODE',0
    s_notfound			    db ' not found!',0
    s_debug_fmt_int		    db ' debug: %d',0
    s_debug_fmt_hex		    db ' debug: 0x%X',0

    s_memdump			    db ' dump 0x%X,s=0x%X',0
    s_written			    db ' dump_return: 0x%X',0
    s_error			    db ' ERROR!',0
    s_shutdown			    db ' SHUTDOWN',0
    s_fileload			    db ' loadfile to 0x%X',0
    s_filesize			    db ' loadsize is %d bytes',0
    s_read			    db ' read: 0x%X', 0
    s_done			    db ' done!',0
    s_fmt			    db ' %s',0
    s_dir			    db ' Dir: %s',0
    s_loadfile_error		    db ' loadfile error (notfound?)',0
    s_dumpmem_error		    db ' dumpmem error: 0x%X',0
    s_uart_newline		    db 0xD,0xA,0
    s_memcpy			    db ' 0x%X=>0x%X,s=0x%X',0
}
