#include "stm32f0xx.h"
//#define __INLINE inline
static __INLINE void StartHSE(void)
{
    /* Configure NVIC for RCC */ 
    /* (1) Enable Interrupt on RCC */ 
    /* (2) Set priority for RCC */  

    NVIC_EnableIRQ(RCC_CRS_IRQn); /* (1)*/ 
    NVIC_SetPriority(RCC_CRS_IRQn,0);/* (2) */  


    /* (1) Enable interrupt on HSE ready */ 
    /* (2) Enable the CSS    
    Enable the HSE and set HSEBYP to use the external clock      
    instead of an oscillator     
    Enable HSE */ 
    /* Note : the clock is switched to HSE in the RCC_CRS_IRQHandler ISR */ 
    RCC->CIR |= RCC_CIR_HSERDYIE;/* (1) */ 
    RCC->CR |= RCC_CR_CSSON | RCC_CR_HSEBYP | RCC_CR_HSEON;/* (2) */  
}

void RCC_CRS_IRQHandler(void)
{  
    /* (1) Check the flag HSE ready */  
    /* (2) Clear the flag HSE ready */  
    /* (3) Switch the system clock to HSE */
    if((RCC->CIR & RCC_CIR_HSERDYF)!=0) /* (1) */
    {    
        RCC->CIR |= RCC_CIR_HSERDYC;/* (2) */    
        RCC->CFGR =(  (RCC->CFGR &(~RCC_CFGR_SW) ) | RCC_CFGR_SW_0  );/* (3) */
    }else{   
        /* Report an error */
    }
}



/* (1)  Test if PLL is used as System clock */
/* (2)  Select HSI as system clock */
/* (3)  Wait for HSI switched */
/* (4)  Disable the PLL */
/* (5)  Wait until PLLRDY is cleared */
/* (6)  Set the PLL multiplier to 6 */
/* (7)  Enable the PLL */ 
/* (8)  Wait until PLLRDY is set */
/* (9)  Select PLL as system clock */
/* (10) Wait until the PLL is switched on */
void PLL_Config(){
    if((RCC->CFGR & RCC_CFGR_SWS)== RCC_CFGR_SWS_PLL) /* (1) */
    {  
        RCC->CFGR &=(uint32_t)(~RCC_CFGR_SW);/* (2) */
        while((RCC->CFGR & RCC_CFGR_SWS)!= RCC_CFGR_SWS_HSI)/* (3) */
        {    /* For robust implementation, add here time-out management */}
    }
    RCC->CR &=(uint32_t)(~RCC_CR_PLLON);/* (4) */ 
    
    while((RCC->CR & RCC_CR_PLLRDY)!=0)/* (5) */
    {  /* For robust implementation, add here time-out management */ }
    
    RCC->CFGR = (RCC->CFGR) &( (~RCC_CFGR_PLLMUL) | (RCC_CFGR_PLLMUL6) );/* (6) */
    RCC->CR |= RCC_CR_PLLON;/* (7) */
    
    while((RCC->CR & RCC_CR_PLLRDY)==0)/* (8) */
    {  /* For robust implementation, add here time-out management */}
    
    RCC->CFGR |=(uint32_t)(RCC_CFGR_SW_PLL);/* (9) */
    
    while((RCC->CFGR & RCC_CFGR_SWS)!= RCC_CFGR_SWS_PLL) /* (10) */
    {  /* For robust implementation, add here time-out management */}
}
