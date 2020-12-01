
/*_boot_checksum = 0 - (_stack_base + main + 1 + (hang + 1) * 5);*/

MEMORY
{
   rom(RX)   : ORIGIN = 0x08000000, LENGTH = 16K
   ram(WAIL) : ORIGIN = 0x20000000, LENGTH = 4K 
}

ld_stack = 0x20001000;

SECTIONS
{
        /* Секция исполняемого кода */
        .text : AT(0x08000000) ALIGN(4) { 
                ld_sisr = . ;
                KEEP(*(.vectors));    

                . = ALIGN(4);
                /* Секция исполняемого кода */
                *(.text)
                *(.text.*)
                /* константы */
                *(.rodata)
                *(.rodata.*)
 
                . = ALIGN(4);
                ld_etext = . ;

        } > rom

        
        /* Секция данных */
        .data : /* AT(0x20000200) ALIGN(4)*/
        {
                ld_sdata = . ;/* create a global symbol at data start */

                *(.data)
                *(.data.*)

                . = ALIGN(4);
                ld_edata = . ;/* create a global symbol at data end */

        } > ram AT > rom

         /* Uninitialized data section */
        .bss : AT (0x20000200) ALIGN(4) 
        {
                ld_sbss = . ;

                *(.bss)
                *(.bss.*)
                *(COMMON)

                . = ALIGN(4);
                ld_ebss = . ;

        } > ram
}
