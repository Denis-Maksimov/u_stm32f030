#include "stm32f0xx.h"
//#include "GPIO.h"
#define ever (;;)
//inline void Init_USART1();

// void send(char chr);
// void PrintRS232(const char* pString);
void sleep(int ticks);
// void init_usart();
void Init_usart(void);
void Transmit(uint16_t Data);
void SystemInit(void);
//--------------------------------


int main(void){
  
//    SystemInit();
  //  asm("cpsid i");
  //  asm("cpsid f");
    Init_usart();
    // Init_USART1();
    while(1){
        Transmit('!');
        //PrintRS232("hello");
        sleep(800000);
      



    }

return 0;
}



//--------------------------------
void sleep(volatile int ticks){
    for(int i=0;i<ticks;i++)
        asm("nop");
}
//--------------------------------
// inline void Init_USART1(){
//     //включаем тактирование
//     RCC->APB2ENR |= RCC_APB2ENR_USART1EN;

//     //настраиваем бодрейд
//     USART1->BRR =(80000/96);

//     //включаем USART и передачу 
//     USART1->CR1 = USART_CR1_TE | USART_CR1_UE;


// }
//--------------------------------
// void send(char chr){

//  while(!(USART1->ISR & USART_ISR_TXE));

//     USART1->TDR = (chr & 0x1FF);
//     /* Clear transfer complete flag */
//     //USART1->ICR |= USART_ICR_TCCF;
//     /* clear transfer complete flag and fill TDR with a new char */    
//     //USART1->TDR = chr;

// }

// void init_usart(){

//     RCC->AHBENR |= RCC_AHBENR_GPIOAEN; /* Enable GPIOA clock */
//     GPIOA->MODER |= GPIO_MODER_MODER9_1; // PA9 as alternative GP Output (USART1_TX)
//     GPIOA->MODER |= GPIO_MODER_MODER10_1; // PA10 as AF

//     GPIOA->OTYPER  &= ~GPIO_OTYPER_OT_9;
//     GPIOA->OTYPER  &= ~GPIO_OTYPER_OT_10;

//     GPIOA->PUPDR   |=  GPIO_PUPDR_PUPDR9_0;
//     GPIOA->PUPDR   |=  GPIO_PUPDR_PUPDR10_0;

//     GPIOA->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR9; //high speed (current?) output
//     GPIOA->AFR[1] |= 0x110; // PA9, PA10 Alternative function 1 (USART1) enable
    
    
//     //включаем тактирование
//     RCC->APB2ENR |= RCC_APB2ENR_USART1EN;

//     //настраиваем бодрейд
//     USART1->BRR =(80000/96);
//     for (int i = 0; i < 0x1000; i++) __NOP();/* avoid unwanted output */
//     //включаем USART и передачу 
//     USART1->CR1 |= USART_CR1_TE | USART_CR1_UE;
// }

//  int getkey (void) {

 

// while (!(USART1->ISR & USART_ISR_RXNE));

// return (USART1->RDR);

// }

// void PrintRS232(const char* pString){
//         USART1->CR1 |= USART_CR1_TE; // Set transmit enable bit
//         while(*pString){                // Print char's as long as not a null char
//                 USART1->TDR = *pString;      // Put char into the data register
//                 while(!(USART1->ISR & USART_ISR_TXE));   // xfer to shift register
//                 pString++;                              // Increment ptr in memory
//         }
// }

#define APBCLK   8000000UL
#define BAUDRATE 115200UL

void Init_usart(void)
{
  // Включить тактирование порта А
  RCC_TypeDef* _RCC=(RCC_TypeDef *)0x40021000;
  _RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
  // Включаем тактирование USART1
  _RCC->APB2ENR |= RCC_APB2ENR_USART1EN|RCC_APB2ENR_SYSCFGEN;
  GPIOA->OTYPER  &= ~GPIO_OTYPER_OT_9;
 GPIOA->PUPDR   |=  GPIO_PUPDR_PUPDR9_0;
//     GPIOA->PUPDR   |=  GPIO_PUPDR_PUPDR10_0;
  GPIOA->MODER   |= GPIO_MODER_MODER9_1;         // PA9 (TX) - Alternate function mode
  GPIOA->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR9;      // PA9 (TX) - High speed
  GPIOA->AFR[1]    |= 0x0110;  //
 
  RCC->CFGR3     &= ~RCC_CFGR3_USART1SW;
  RCC->CFGR3     |=  RCC_CFGR3_USART1SW_0;  //System clock (SYSCLK) selected as USART1 clock
 
 
  
  USART1->CR1 &= ~USART_CR1_M; //Данные - 8 бит
  USART1->CR2 &= ~USART_CR2_STOP; //1 стоп-бит
  USART1->BRR =((APBCLK+BAUDRATE/2)/BAUDRATE); //скорость usart
  USART1->CR1 |= USART_CR1_TE; //Включаем передатчик USART1
  USART1->CR1 |= USART_CR1_RE; //Включаем приемник USART1
  USART1->CR1 |= USART_CR1_UE; //Включаем USART1
}

void Transmit(uint16_t Data)
{
  //while(!(USART1->ISR & USART_ISR_TC));
  USART1->ISR =0;
  USART1->TDR = (Data & (uint16_t)0x01FF);
}


void SystemInit(void)
{
  /* Reset the RCC clock configuration to the default reset state ------------*/
  /* Set HSION bit */
  RCC->CR |= (uint32_t)0x00000001U;
/* Reset SW[1:0], HPRE[3:0], PPRE[2:0], ADCPRE, MCOSEL[2:0], MCOPRE[2:0] and PLLNODIV bits */
  RCC->CFGR &= (uint32_t)0x08FFB80CU;
  /* Reset HSEON, CSSON and PLLON bits */
  RCC->CR &= (uint32_t)0xFEF6FFFFU;

  /* Reset HSEBYP bit */
  RCC->CR &= (uint32_t)0xFFFBFFFFU;

  /* Reset PLLSRC, PLLXTPRE and PLLMUL[3:0] bits */
  RCC->CFGR &= (uint32_t)0xFFC0FFFFU;

  /* Reset PREDIV[3:0] bits */
  RCC->CFGR2 &= (uint32_t)0xFFFFFFF0U;
  /* Reset USART1SW[1:0], I2C1SW and ADCSW bits */
  RCC->CFGR3 &= (uint32_t)0xFFFFFEECU;
  /* Reset HSI14 bit */
  RCC->CR2 &= (uint32_t)0xFFFFFFFEU;

  /* Disable all interrupts */
  RCC->CIR = 0x00000000U;
}