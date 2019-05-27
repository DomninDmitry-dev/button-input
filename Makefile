KDIR = $(HOME)/CreateImageOP/cache/sources/linux-mainline/linux-4.14.y
//KDIR = /lib/modules/$(shell uname -r)/build
ARCH = arm
CCFLAGS = -C
COMPILER = arm-unknown-linux-gnueabihf-
//COMPILER = arm-linux-gnueabihf-
PWD = $(shell pwd)
TARGET_MOD = button_input
REMFLAGS = -g -O0

# Опция -g - помещает в объектный или исполняемый файл информацию необходимую для 
# работы отладчика gdb. При сборке какого-либо проекта с целью последующей отладки, 
# опцию -g необходимо включать как на этапе компиляции так и на этапе компоновки.

# Опция -O0 - отменяет какую-либо оптимизацию кода. Опция необходима на этапе 
# отладки приложения. Как было показано выше, оптимизация может привести к 
# изменению структуры программы до неузнаваемости, связь между исполняемым и 
# исходным кодом не будет явной, соответственно, пошаговая отладка программы 
# будет не возможна. При включении опции -g, рекомендуется включать и -O0.

obj-m   := $(TARGET_MOD).o 
CFLAGS_$(TARGET_MOD).o := -DDEBUG

all:
	$(MAKE) $(CCFLAGS) $(KDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(COMPILER) modules
															 
copy_dtbo:
	@./mod.sh copy-dtbo
copy_dtb:
	@./mod.sh copy-dtb
del_mod:
	@./mod.sh delete-ko
copy_mod:
	@./mod.sh copy-ko
compile_dts:
	@./mod.sh compile-dts
compile_dtsi:
	@./mod.sh compile-dtsi
	
reboot_dev:
	@./mod.sh reboot
															 
clean: 
	@rm -f *.o .*.cmd .*.flags *.mod.c *.order *.dwo *.mod.dwo .*.dwo
	@rm -f .*.*.cmd *~ *.*~ TODO.*
	@rm -fR .tmp* 
	@rm -rf .tmp_versions
	@rm -f *.ko *.symvers