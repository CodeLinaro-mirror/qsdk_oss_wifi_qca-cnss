M ?= $(shell pwd)
KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build

obj-m += qca-cnss2.o

ifneq ($(QCA_CNSS_STREAM_MOD),)
ifneq ($(CONFIG_BUILD_OWRT),y)
obj-m += qca-cnss2_stream.o
endif
endif

qca-cnss2-objs := main.o
qca-cnss2-objs += debug.o
qca-cnss2-objs += pci.o
qca-cnss2-objs += power.o
qca-cnss2-objs += qmi.o
qca-cnss2-objs += wlan_firmware_service_v01.o
qca-cnss2-objs += bus.o
qca-cnss2-objs += genl.o
qca-cnss2-objs += cnss_plat_ipc_qmi.o
qca-cnss2-objs += cnss_plat_ipc_service_v01.o
qca-cnss2-objs += legacyirq/legacyirq.o
qca-cnss2_stream-objs := stream.o

CNSS2_INCLUDE = -I$(obj)
CNSS2_INCLUDE += -I$(obj)/include

ccflags-y += -DCONFIG_CNSS_OUT_OF_TREE
ccflags-y += -DCONFIG_CNSS2_QMI
ccflags-y += -DCONFIG_PCI_MSM
ccflags-y += -DCONFIG_MHI_BUS_MISC
ccflags-y += -DCONFIG_CNSS2_DEBUG
ccflags-y += $(CNSS2_INCLUDE)
ccflags-y += -Wall -Werror -Wno-format-security -Wno-void-pointer-to-int-cast

ccflags-y += -DCONFIG_CNSS_QCN9000
ccflags-y += -DCONFIG_CNSS2_GENL

ifeq ($(CONFIG_BUILD_YOCTO),y)
	ccflags-y += -DCONFIG_CNSS2_KERNEL_5_15
	ccflags-y += -DCONFIG_CNSS2_DMA_ALLOC
	ccflags-y += -DCONFIG_CNSS2_SMMU
else ifeq ($(CONFIG_BUILD_OWRT),y)
	ccflags-y += -DCONFIG_CNSS2_DMA_ALLOC
	ccflags-y += -DCONFIG_CNSS2_SMMU
	ccflags-y += -DCONFIG_CNSS2_KERNEL_5_15
else
	ccflags-y += -DCONFIG_CNSS2_KERNEL_IPQ
	ccflags-y += -DCONFIG_CNSS2_QGIC2M
	ccflags-y += -DCONFIG_CNSS2_KERNEL_RPROC_FRAMEWORK
	ccflags-y += -DCONFIG_CNSS2_LEGACY_IRQ
endif

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) V=1 modules

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules_install

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) clean
