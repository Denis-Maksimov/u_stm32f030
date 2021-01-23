#include "stm_cmsis.h"
// typedef uint32_t u32;
// typedef uint16_t u16;
// typedef uint8_t u8;

// typedef int32_t s32;
// typedef int16_t s16;
// typedef int8_t s8;



typedef struct{
    u32 stv;
    // u32 value;
    u8 state;
    // u8 state_pext:1;
}u_timer;


u32 s_pulse(u_timer* Tx, u32 tv, u16 set, u16 rst)
{
    if ((!set)||(rst)) {Tx->state=0; return 0;}
    if(!(Tx->state)){
        Tx->state=1;
        // Tx->value=tv;
        Tx->stv=SysTick->VAL;
    }

        if (SysTick->VAL - Tx->stv < tv) return 1;

    return 0;
}

u32 s_pext(u_timer* Tx, u32 tv, u16 set, u16 rst)
{
    if ((rst)) {Tx->state=0; return 0;}
    if (set && (!(Tx->state)))
    {
        Tx->state=1;
        // Tx->value=tv;
        Tx->stv=SysTick->VAL;
    }

    if (SysTick->VAL - Tx->stv < tv) return 1;
    if (!set) Tx->state=0;
    return 0;
}

u32 s_odt(u_timer* Tx, u32 tv, u16 set, u16 rst)
{
    if ((rst)) {Tx->state=0; return 0;}
    if (set && (!(Tx->state)))
    {
        Tx->state=1;
        // Tx->value=tv;
        Tx->stv=SysTick->VAL;
    }

    if (SysTick->VAL - Tx->stv < tv) return 0;
    if (!set) Tx->state=0;
    return Tx->state;
}

u32 s_odts(u_timer* Tx, u32 tv, u16 set, u16 rst)
{
    if ((rst)) {Tx->state=0; return 0;}
    if (set && (!(Tx->state)))
    {
        Tx->state=1;
        // Tx->value=tv;
        Tx->stv=SysTick->VAL;
    }

    if (SysTick->VAL - Tx->stv < tv) return 0;
    return Tx->state;
}

u32 s_offdt(u_timer* Tx, u32 tv, u16 set, u16 rst)
{
    if ((rst)) {Tx->state=0; return 0;}
    if (set)
    {
        Tx->state=1;
        // Tx->value=tv;
        Tx->stv=SysTick->VAL;
    }

    if (SysTick->VAL - Tx->stv < tv) return Tx->state;
    Tx->state=0;
    return Tx->state;
}



typedef struct 
{
    u32 durations[25];
    u16 n;
    u_timer periodic;
}knock;


s32 recording(knock* obj)
{
    if(obj->n >= 24)return -1;
    //-- выполняться раз в 200 мс!
    if(s_pext(&(obj->periodic),200,!obj->periodic.state,0)) return 0;//pass
    if(GPIOA->IDR&0x01){
        obj->n++;
        if(obj->n > 25-1)return 1;//end memory
        obj->durations[obj->n]=0;
    }else{
        obj->durations[obj->n]++;
    }
    
    if(obj->durations[obj->n]>25) return 2;//timeout
    return 0;//pass
}

s32 compare(knock* A, knock* B)
{
    if(A->n != B->n) return -1; //false
    //normalize A
    //--find max A, min A
    //--расстянуть до максимума
    //--округлить до промежутков дискретизации
    normalize(A);

    // normalize B
    normalize(B);

    for (int i = 0; i < A->n; i++)
    {
        
        if(cmp(A->durations[i],B->durations[i], 1000)) return -2; //false
    }
    return 0;
    
}

s8 cmp(u32 a,u32 b, u32 delta_max)
{
    if(a>b){
        if((a-b)>delta_max) return 1;
    }else{
        if((b-a)>delta_max) return 2;
    }
    return 0;
}

void normalize(knock* A)
{
    u32 max=find_max(A->durations,A->n);
    u32 min=find_premin(A->durations,A->n);
    nmap(A->durations,A->n,min,max);

}

u32 find_max(u32* arr,u16 n)
{
    u32 max=0;
    for (u16 i = 0; i < n; i++)
    {
        max=(arr[i]>max)?(arr[i]):(max);
    }
    return max;
}

u32 find_premin(u32* arr,u16 n)
{
    u32 min=0xffffffff;
    for (u16 i = 0; i < n; i++)
    {
        if(!arr[i]) continue;
        min=(arr[i]<min)?(arr[i]):(min);
    }
    return min;
}

void nmap(u32* arr,u16 n,u32 min, u32 max)
{
    u32 coeff=0xffffffff/(max-min);
    for (u16 i = 0; i < n; i++)
    {
        arr[i]-=min;
        arr[i]/=coeff;
    }
    
}

float a(float b){
    return b*b;
}
