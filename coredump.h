/* Copyright (c) 2024, Qualcomm Innovation Center, Inc. All rights reserved.
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

#ifndef _COREDUMP_H_
#define _COREDUMP_H_

#include "qmi/qmi.h"
#include "main.h"

#define MAX_NUMBER_OF_SOCS	5
#define CNSS_FW_CRASH_DUMP_VERSION 1
#define CNSS_FW_CRASH_DUMP_V2      2

/* need to unified this macro like upstream */
enum cnss_fw_crash_dump_type {
	CNSS_FW_CRASH_PAGING_DATA,
	CNSS_FW_CRASH_RDDM_DATA,
	CNSS_FW_REMOTE_MEM_DATA,
	CNSS_FW_PAGEABLE_DATA,
	CNSS_FW_M3_DUMP,
	CNSS_FW_QDSS_DATA,
	CNSS_FW_CALDB,
	CNSS_FW_AFC,
	CNSS_FW_MLO_GLOBAL,
};

struct cnss_dump_segment {
	unsigned long addr;
	void *vaddr;
	unsigned int len;
	unsigned int type;
};

struct cnss_dump_file_data {
	/* "CNSS-FW-DUMP" */
	char df_magic[16];
	__le32 len;
	/* file dump version */
	__le32 version;
	/* pci device id */
	__le32 chip_id;
	/* qrtr instance id */
	__le32 qrtr_id;
	/* pci domain id */
	u8 bus_id;
	guid_t guid;
	/* time-of-day stamp */
	__le64 tv_sec;
	/* time-of-day stamp, nano-seconds */
	__le64 tv_nsec;
	/* room for growth w/out changing binary format */
	u8 unused[8];
	/* number of segments */
	__le32 num_seg;
	/* cnss_dump_segment struct size */
	__le32 seg_size;

	struct cnss_dump_segment *seg;
	/* struct cnss_dump_segment + more */

	u8 data[0];
} __packed;

struct cnss_coredump_state {
	struct cnss_dump_file_data *header;
	struct cnss_dump_segment *segments;
	struct completion dump_done;
	u32 num_seg;
};

struct cnss_coredump_segment_info {
	 u32 chip_id;
	 u32 qrtr_id;
	 u32 num_seg;
	 struct cnss_dump_segment *seg;
	 u8 bus_id;
};

struct cnss_coredump_info {
	atomic_t num_chip;
	struct cnss_coredump_segment_info chip_seg_info[MAX_NUMBER_OF_SOCS];
};

#ifdef CONFIG_WANT_DEV_COREDUMP
void cnss_coredump_download_rddm(struct cnss_plat_data *plat_priv);
void cnss_coredump_build_inline(struct cnss_plat_data *plat_priv,
				  struct cnss_dump_segment *segments, int num_seg);
void cnss_coredump_qdss_dump(struct cnss_plat_data *plat_priv,
			       struct cnss_qmi_event_qdss_trace_save_data *event_data);
void cnss_coredump_m3_dump(struct cnss_plat_data *plat_priv,
			     struct cnss_qmi_event_m3_dump_upload_req_data *event_data);
#else
static inline void cnss_coredump_download_rddm(struct cnss_plat_data *plat_priv)
{
}

static inline void cnss_coredump_build_inline(struct cnss_plat_data *plat_priv,
						struct cnss_dump_segment *segments,
						int num_seg)
{
}
static inline void
cnss_coredump_qdss_dump(struct cnss_plat_data *plat_priv,
			  struct cnss_qmi_event_qdss_trace_save_data *event_data)
{
}
static inline void
cnss_coredump_m3_dump(struct cnss_plat_data *plat_priv,
			struct wlfw_m3_dump_upload_req_ind_msg_v01 *event_data)
{
}
#endif
#endif
