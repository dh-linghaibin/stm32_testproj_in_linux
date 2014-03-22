#include"stm32f10x.h"
#include"misc.h"

void GPIO_Conf(void);
void NVIC_Conf(void);

int main(){
	int i, j;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOD|RCC_APB2Periph_GPIOE|RCC_APB2Periph_GPIOG|RCC_APB2Periph_AFIO, ENABLE);
	GPIO_Conf();
	
	while(1){
		for(i = 0; i < 1000; i++)
			for(j = 0; j < 1000; j++)
				;
			GPIO_SetBits(GPIOD, GPIO_Pin_13);
			GPIO_ResetBits(GPIOG, GPIO_Pin_14);
		for(i = 0; i < 1000; i++)
			for(j = 0; j < 1000; j++)
				;
			GPIO_ResetBits(GPIOD, GPIO_Pin_13);
			GPIO_SetBits(GPIOG, GPIO_Pin_14);
	}
}

void GPIO_Conf(void){
	GPIO_InitTypeDef GPIO_InitStr;
	GPIO_InitStr.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStr.GPIO_Pin = GPIO_Pin_13;
	GPIO_InitStr.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOD, &GPIO_InitStr);
	GPIO_InitStr.GPIO_Pin = GPIO_Pin_14;
	GPIO_Init(GPIOG, &GPIO_InitStr);
}
