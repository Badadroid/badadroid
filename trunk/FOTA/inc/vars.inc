;default vars and strings to be used by functions, to avoid mess in main file

macro DEFAULT_VARIABLES
{
    fota_x dw x_pos@disp_FOTA_Printf_1

    ;delays are given in nanoseconds
    v_delay_100ms	dw 100000
    v_delay_800ms	dw 800000
    v_delay		dw 4000000
}
macro DEFAULT_STRINGS_ADDR
{
    s_fmt_a		dw s_fmt
    s_dir_a		dw s_dir
    s_debug_fmt_a	dw s_debug_fmt
    s_notfound_a	dw s_notfound
    s_downloadmode_a	dw s_downloadmode
    s_memdump_a 	dw s_memdump
    s_done_a		dw s_done
    s_written_a 	dw s_written
    s_fileload_a	dw s_fileload
    s_read_a		dw s_read
    s_error_a		dw s_error	
}
macro DEFAULT_STRINGS
{
    s_downloadmode		    db ' ENTERING DOWNLOAD MODE',0
    s_notfound			    db ' not found!',0
    s_debug_fmt 		    db ' debug: %d',0
    s_memdump			    db ' dump 0x%X - 0x%X',0
    s_written			    db ' written: 0x%X',0
    s_error			    db ' ERROR!',0
    s_shutdown			    db ' SHUTDOWN',0
    s_fileload			    db ' load 0x%X - 0x%X',0
    s_read			    db ' read: 0x%X', 0
    s_done			    db ' done!',0
    s_fmt			    db ' %s',0
    s_dir			    db ' Dir: %s',0   
}
