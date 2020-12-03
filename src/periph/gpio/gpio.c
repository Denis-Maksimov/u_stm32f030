/*


           _____________
    BOOT0-|             |-PA14 
    PF0  -|             |-PA13
    PF1  -|             |-PA10
    RST  -|             |-PA9
    VDDA -|             |-VDD
    PA0  -|             |-VSS
    PA1  -|             |-PB1
    PA2  -|             |-PA7
    PA3  -|             |-PA6
    PA4  -|_____________|-PA5

**************************************
Input floating 
Input pull-up
Input-pull-down
Analog
Output open-drain with pull-up or pull-down capability
Output push-pull with pull-up or pull-down capability
Alternate function push-pull with pull-up or pull-down capability
Alternate function open-drain with pull-up or pull-down capability

*/

#include "gpio.h"

void gpio_accept_settings(u_gpio* gpio_A)
{
    RCC->AHBENR|=RCC_AHBENR_GPIOAEN;

    GPIOA->MODER &= ~(AI  << (gpio_A->pin<<1));
    GPIOA->MODER |= (gpio_A->mode << (gpio_A->pin<<1));
    
    GPIOA->OTYPER &= ~(GPIO_OTYPER_OT_0 << gpio_A->pin);
    GPIOA->OTYPER |=  (gpio_A->PP_PD << gpio_A->pin);

    GPIOA->OSPEEDR &= ~(high <<  (gpio_A->pin<<1));
    GPIOA->OSPEEDR |=  (gpio_A->speed << (gpio_A->pin<<1));
}


