DEV_KERNEL_DIR = 4.19.59-sunxi
HOST_KERNEL_DIR = orange-pi-4.19.59
PROJ_NAME = driver-button-input
DEV_ROOT_IP = root@192.168.0.120
MOD_DIR = gpio
DTB_NAME = sun8i-h3-orangepi-one
USER_DIR=dmitry

ifeq ($(shell uname -r), $(DEV_KERNEL_DIR))
	KDIR = /lib/modules/$(shell uname -r)/build
else
	#KDIR = $(HOME)/CreateImage/cache/sources/linux-mainline/linux-4.19.y
	KDIR = $(HOME)/Kernels/$(HOST_KERNEL_DIR)
endif

ARCH = arm
CCFLAGS = -C
COMPILER_PROG = arm-unknown-linux-gnueabihf-
COMPILER = arm-linux-gnueabihf-
PWD = $(shell pwd)
TARGET_MOD = button_input
TARGET_PROG = test
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
ifeq ($(shell uname -r), $(DEV_KERNEL_DIR))
	$(MAKE) $(CCFLAGS) $(KDIR) M=$(PWD) modules
else
	$(MAKE) $(CCFLAGS) $(KDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(COMPILER) modules
endif

test: $(TARGET_PROG).cpp
ifeq ($(shell uname -r), $(DEV_KERNEL_DIR))
	g++ $(TARGET_PROG).cpp -o $(TARGET_PROG) $(REMFLAGS)
else
	$(COMPILER_PROG)g++ $(TARGET_PROG).cpp -o $(TARGET_PROG) $(REMFLAGS)
endif

copy_dtbo:
	@./commands.sh -c copy-dtbo -projname $(PROJ_NAME) -devip $(DEV_ROOT_IP)
copy_dtb:
	@./commands.sh -c copy-dtb -hostdir $(HOST_KERNEL_DIR) -devip $(DEV_ROOT_IP) -dtbname $(DTB_NAME)
del_mod:
	@./commands.sh -c delete-ko -devdir $(DEV_KERNEL_DIR) -devip $(DEV_ROOT_IP) -moddir $(MOD_DIR)
copy_mod:
	@./commands.sh -c copy-ko -projname $(PROJ_NAME) -devdir $(DEV_KERNEL_DIR) -devip $(DEV_ROOT_IP) -moddir $(MOD_DIR)
compile_dts:
	@./commands.sh -c compile-dts -projname $(PROJ_NAME) -hostdir $(HOST_KERNEL_DIR) -comp $(COMPILER) -dtbname $(DTB_NAME)
compile_dtsi:
	@./commands.sh -c compile-dtsi -projname $(PROJ_NAME)
reboot_dev:
	@./commands.sh -c reboot -devip $(DEV_ROOT_IP)
copy_prog:
	@./commands.sh -c copy-prog -projname $(PROJ_NAME) -devip $(DEV_ROOT_IP) -userdir $(USER_DIR)

clean:
	@rm -f *.o .*.cmd .*.flags *.mod.c *.order *.dwo *.mod.dwo .*.dwo
	@rm -f .*.*.cmd *~ *.*~ TODO.*
	@rm -fR .tmp*
	@rm -rf .tmp_versions
	@rm -f *.ko *.symvers
