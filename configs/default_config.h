/*
 * Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 and
 * only version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#ifndef CONFIG_TO_CNSS_FEATURE_H
#define CONFIG_TO_CNSS_FEATURE_H

#ifdef CONFIG_QCA_CNSS_PCI_SUPPORT
#define CNSS_PCI_SUPPORT  (1)
#endif

#ifdef CONFIG_QCA_CNSS_DEBUG_SUPPORT
#define  CNSS_DEBUG_SUPPORT (1)
#endif

#ifdef CONFIG_BUILD_YOCTO
#define CONFIG_CNSS2_KERNEL_MSM (1)
#define CONFIG_CNSS2_DMA_ALLOC (1)
#define CONFIG_CNSS2_SMMU (1)
#define CONFIG_CNSS2_KERNEL_SSR_FRAMEWORK (1)
#elif defined(CONFIG_BUILD_OWRT)
#define CONFIG_CNSS2_DMA_ALLOC (1)
#define CONFIG_CNSS2_SMMU (1)
#define CONFIG_CNSS2_KERNEL_5_15 (1)
#else
#define CONFIG_CNSS2_KERNEL_IPQ (1)
#define CONFCONFIG_CNSS2_QGIC2M (1)
#define CONFCONFIG_CNSS2_KERNEL_RPROC_FRAMEWORK (1)
#ifdef CONFIG_QCA_CNSS_PCI_SUPPORT
#define CONFIG_CNSS2_LEGACY_IRQ (1)
#endif
#ifdef CONFIG_QCA_CNSS_DEPENDENCY
#define CONFIG_CNSS2_QCOM_KERNEL_DEPENDENCY (1)
#endif
#endif

#ifdef CONFIG_TARGET_sdx75
#define CONFIG_TARGET_SDX75 (1)
#endif

#ifdef CONFIG_TARGET_sdx85
#define CONFIG_TARGET_SDX85 (1)
#endif

#ifdef CONFIG_QCA_CNSS_LOWMEM_PROFILE
#define CNSS_LOWMEM_PROFILE (1)
#endif

#ifdef CONFIG_ENABLE_FW_MOUNT_SUPPORT
#define CNSS_FW_MOUNT_SUPPORT (1)
#endif

#ifndef CONFIG_TARGET_SDX_WKK
#define CONFIG_TARGET_SDX_WKK (1)
#endif

#endif /* CONFIG_TO_CNSS_FEATURE_H */
