#include "main.h"
#include "gpio.h"
/*
*            _____________
    BOOT0-|             |-PA14 
    PF0  -|             |-PA13
    PF1  -|             |-PA10
    RST  -|             |-PA9
    VDDA -|             |-VDD
    PA0  -|             |-VSS
PWM PA1  o|             |-PB1
    PA2  -|             |-PA7
    PA3  -|             |-PA6
    PA4  -|_____________|-PA5
*     
* */
void leds_init(u_gpio* gpio_A1){


  gpio_A1->mode=AF;
  gpio_A1->pin=1;
  gpio_A1->PP_PD=push_pull;
  gpio_A1->speed=high;
  gpio_accept_settings(gpio_A1);




}

void PWM_init(){
  /* (1) Set prescaler to 47, so APBCLK/48 i.e 1MHz */
  /* (2) Set ARR = 8, as timer clock is 1MHz the period is 9 us */
  /* (3) Set CCRx = 4, , the signal will be high during 4 us */
  /* (4) Select PWM mode 1 on OC1 (OC1M = 110),
         enable preload register on OC1 (OC1PE = 1) */
  /* (5) Select active high polarity on OC1 (CC1P = 0, reset value),
         enable the output on OC1 (CC1E = 1)*/
  /* (6) Enable output (MOE = 1)*/
  /* (7) Enable counter (CEN = 1)
         select edge aligned mode (CMS = 00, reset value)
         select direction as upcounter (DIR = 0, reset value) */
  /* (8) Force update generation (UG = 1) */
  TIMx->PSC =7;/* (1) */
  TIMx->ARR =8;/* (2) */
  TIMx->CCR1 =4;/* (3) */
  TIMx->CCMR1 |= TIM_CCMR1_OC1M_2 | TIM_CCMR1_OC1M_1| TIM_CCMR1_OC1PE;/* (4) */
  TIMx->CCER |= TIM_CCER_CC1E;/* (5) */
  TIMx->BDTR |= TIM_BDTR_MOE;/* (6) */
  TIMx->CR1 |= TIM_CR1_CEN;/* (7) */
  TIMx->EGR |= TIM_EGR_UG;/* (8) */
}


void leds_process(){
  //прочитать крутилку-задаваку
  //и захуярить как X

  //прочитать аналоговый вход Y

  //расчитать ПИД

  //выдать коэф. заполнения ШИМ

}

void main()
{
  u_gpio gpio_A1;
  leds_init(&gpio_A1);

  while (1)
  {
    leds_process();
    
  }
  
}
