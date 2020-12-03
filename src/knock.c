#include "stm_cmsis.h"

u32 __systick_value;


typedef struct{
    u32 tv;
    u32 value;
    u8 state;
}u_timer;


u32 s_pulse(u_timer* Tx, u32 tv, u16 set, u16 rst)
{
    if ((!set)||(rst)) {Tx->state=0; return 0;}
    if(Tx->state!){
        Tx->state=1;
        Tx->value=tv;
        Tx->tv=__systick_value;
        

    }
}


void processing(){



}






