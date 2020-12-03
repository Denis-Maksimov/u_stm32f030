#include "ADC.h"


void ADC_enable()
{
    /* (1) Ensure that ADRDY = 0 */
    /* (2) Clear ADRDY */
    /* (3) Enable the ADC */
    /* (4) Wait until ADC ready */
    if((ADC1->ISR & ADC_ISR_ADRDY)!=0)/* (1) */
    {  
        ADC1->ISR |= ADC_ISR_ADRDY; /* (2) */
    }
    ADC1->CR |= ADC_CR_ADEN;/* (3) */
    while((ADC1->ISR & ADC_ISR_ADRDY)==0)/* (4) */
    {/* For robust implementation, add here time-out management */}

}
void init_ADC()
{
    /* This code selects the HSI14 as clock source. */
    /* (1) Enable the peripheral clock of the ADC */
    /* (2) Start HSI14 RC oscillator */
    /* (3) Wait HSI14 is ready */
    /* (4) Select HSI14 by writing 00 in CKMODE (reset value) */
    RCC->APB2ENR |= RCC_APB2ENR_ADC1EN;/* (1) */
    RCC->CR2 |= RCC_CR2_HSI14ON;/* (2) */
    while((RCC->CR2 & RCC_CR2_HSI14RDY)==0)/* (3) */
    {/* For robust implementation, add here time-out management */}
    ADC1->CFGR2 &= (~ADC_CFGR2_CKMODE); /* (4) */

    ADC_callib();
    ADC_enable();
    ADC1->CHSELR = ADC_CHSELR_CHSEL0;
    ADC1->SMPR |= ADC_SMPR_SMP_0 | ADC_SMPR_SMP_1 | ADC_SMPR_SMP_2;
    

}

void ADC_callib()
{
    /* (1) Ensure that ADEN = 0 */
    /* (2) Clear ADEN by setting ADDIS*/
    /* (3) Clear DMAEN */
    /* (4) Launch the calibration by setting ADCAL */
    /* (5) Wait until ADCAL=0 */
    if((ADC1->CR & ADC_CR_ADEN)!=0)/* (1) */
    {
          ADC1->CR |= ADC_CR_ADDIS; /* (2) */
    }
    while((ADC1->CR & ADC_CR_ADEN)!=0)
    {/* For robust implementation, add here time-out management */}
    ADC1->CFGR1 &= ~ADC_CFGR1_DMAEN;/* (3) */
    ADC1->CR |= ADC_CR_ADCAL;/* (4) */

    while((ADC1->CR & ADC_CR_ADCAL)!=0)/* (5) */
    {/* For robust implementation, add here time-out management */}
}

