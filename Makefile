
FOLDERS :=$(shell find . -type d)
FOLDERS:=$(addprefix -I, $(FOLDERS))

CFLAGS := -nostdlib -nostartfiles -ffreestanding\
		 -Wall -mcpu=cortex-m0 -march=armv6-m -mthumb -O2 -c\

CFLAGS :=$(CFLAGS) $(FOLDERS)

#ларчик, блять, просто открывался, ёбанный soft fp в этой библиотеке спрятан, ёба, год ебался
#даже, блять, реализацию fixed point сделал из-за этой выбляди уёбской
#из-за неё мой мозг знает такое словосочетание как аппроксимация Паде,
#умеет чуть ли ни в уме Тейлора считать, интерполяцию Гаусовой функции навскидку проводить..
#всякую хуйню что мол сдвиг влево это умножение на 2, вправо деление.. да ну нахуй!
#проебал год жизни и пиздатую девушку, и всё блять из-за -lgcc??? Ёбаный стыд, я в ахуе....
#даже военкомат со мной так не поступал..
LDFLAGS := -L/usr/lib/gcc/arm-none-eabi/7.3.1/thumb/ -lgcc



FILES :=$(shell find . -name '*.c')
OBJ:=$(patsubst %.c, %.o,$(FILES))

start: binary.bin




boot.o:	./core/boot.s
		#1 Готовим ассемблерный файл
		arm-none-eabi-as ./core/boot.s -o boot.o
		

bin: $(FILES)
		#2 компилим
		arm-none-eabi-gcc $(FILES) $(CFLAGS)
		

build.elf: bin boot.o
		#3 Линкуем
		arm-none-eabi-ld -o build.elf -T link.ld *.o $(LDFLAGS)
		#arm-none-eabi-ld -o build.elf -T stm32_flash.ld *.o

binary.bin: build.elf
		#4 Извлекаем бинарные данные
		arm-none-eabi-objcopy build.elf binary.bin -O binary
		size build.elf
		

upload: binary.bin
		#Загружаем в МК
		sudo stm32flash -w binary.bin  -v -g 0x0 /dev/ttyUSB0



clean:
		rm -f $(shell find . -name '*.o')
		rm -f $(shell find . -name '*.elf')
		rm -f $(shell find . -name '*.bin')



