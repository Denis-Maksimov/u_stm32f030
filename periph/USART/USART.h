#ifndef USART_H
#define USART_H



#include "stm32.h"
#include "GPIO.h"

void USART_init(void);
void USART_sendChr(char Ch);
void USART_sendString(char* STR);
int USART_sendStringi(char* STR,int i);




#endif // !USART_H
