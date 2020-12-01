#pragma once
#include "stm32.h"

extern unsigned int _System_Clock;

void wait(volatile int i);
void clock(void); //настройка тактирования
//void _RST(void); //SW reset
