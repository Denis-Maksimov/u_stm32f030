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
#include "stm_cmsis.h"



#define GPIOA_MODE ((volatile struct gpio_mode*)(&(GPIOA->MODER)))


// typedef enum{
//     in,//Input floating 
//     in_pullup,//Input pull-up
//     in_pulldown,//Input-pull-down
//     AI,//Analog
//     DQ_open_drain,//Output open-drain with pull-up or pull-down capability
//     DQ_push_pull,//Output push-pull with pull-up or pull-down capability
//     AF_push_pull,//Alternate function push-pull with pull-up or pull-down capability
//     AF_open_drain//Alternate function open-drain with pull-up or pull-down capability
// }gpio_mode;


typedef enum{
    DQ = 0b01,
    AF = 0b10,
    DI = 0b00,
    AI = 0b11
}gpio_mode;

typedef enum{
    push_pull = 0b1,
    open_drain = 0b0,
}gpio_pull;

typedef enum{
    low     = 0b00,
    medium  = 0b01,
    high    = 0b11,
}gpio_speed;

typedef struct 
{
    uint8_t pin;
    gpio_mode mode;
    gpio_speed speed;
    gpio_pull PP_PD;

}u_gpio;


void gpio_accept_settings(u_gpio* gpio_A);
