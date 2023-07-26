M ?= $(shell pwd)
KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build

obj-m += ipq_cnss2.o

ifneq ($(QCA_CNSS_STREAM_MOD),)
ifneq ($(CONFIG_BUILD_OWRT),y)
ifneq ($(QCA_CNSS_LINUX_6_1_SUPPORT),y)
obj-m += ipq_cnss2_stream.o
endif
endif
endif

ipq_cnss2-objs := main.o
ipq_cnss2-objs += debug.o
ipq_cnss2-objs += pci.o
ipq_cnss2-objs += power.o
ipq_cnss2-objs += qmi.o
ipq_cnss2-objs += wlan_firmware_service_v01.o
ipq_cnss2-objs += bus.o
ipq_cnss2-objs += genl.o
ipq_cnss2-objs += cnss_plat_ipc_qmi.o
ipq_cnss2-objs += cnss_plat_ipc_service_v01.o
ifneq ($(CONFIG_BUILD_OWRT),y)
ipq_cnss2-objs += legacyirq/legacyirq.o
endif
ipq_cnss2_stream-objs := stream.o

CNSS2_INCLUDE = -I$(obj)
CNSS2_INCLUDE += -I$(obj)/include

ccflags-y += $(CNSS2_INCLUDE)
ccflags-y += -Wall -Werror -Wno-format-security
ifeq ($(QCA_CNSS_LINUX_6_1_SUPPORT),y)
ccflags-y += -Wno-implicit-fallthrough
endif

ccflags-y += -DCONFIG_CNSS_QCN9000
ccflags-y += -DCONFIG_CNSS2_GENL

ifeq ($(CONFIG_BUILD_YOCTO),y)
	ccflags-y += -DCONFIG_CNSS2_KERNEL_MSM
	ccflags-y += -DCONFIG_CNSS2_DMA_ALLOC
	ccflags-y += -DCONFIG_CNSS2_SMMU
	ccflags-y += -DCONFIG_CNSS2_KERNEL_SSR_FRAMEWORK
else ifeq ($(CONFIG_BUILD_OWRT),y)
	ccflags-y += -DCONFIG_CNSS2_DMA_ALLOC
	ccflags-y += -DCONFIG_CNSS2_SMMU
	ccflags-y += -DCONFIG_CNSS2_KERNEL_5_15
else
	ccflags-y += -DCONFIG_CNSS2_KERNEL_IPQ
	ccflags-y += -DCONFIG_CNSS2_QGIC2M
	ccflags-y += -DCONFIG_CNSS2_KERNEL_RPROC_FRAMEWORK
	ccflags-y += -DCONFIG_CNSS2_LEGACY_IRQ
ifeq ($(QCA_CNSS_KERNEL_DEPENDENCY),y)
	ccflags-y += -DCONFIG_CNSS2_QCOM_KERNEL_DEPENDENCY
endif
ifeq ($(QCA_CNSS_LINUX_6_1_SUPPORT),y)
	ccflags-y += -DCONFIG_CNSS2_KERNEL_6_1
endif
endif

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) V=1 modules

modules_install:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules_install

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) clean
