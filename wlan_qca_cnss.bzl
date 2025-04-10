load("//build/bazel_common_rules/dist:dist.bzl", "copy_to_dist_dir")
load("//build/kernel/kleaf:kernel.bzl", "ddk_module")
load("//msm-kernel:target_variants.bzl", "get_all_variants")

_conditional_srcs = {
    "CONFIG_QCA_CNSS_PCI_SUPPORT": {
        True: [
            "pci/pci.c",
        ],
    },
    "CONFIG_QCA_CNSS_DEBUG_SUPPORT": {
        True: [
            "debug/debug.c",
        ],
    },
    "CONFIG_BUILD_OWRT": {
        False: [
            "legacyirq/legacyirq.c",
        ],
    },
    "CONFIG_QCA_STREAM" : {
        True: [
           "stream.c",
        ],
    },
}

_fixed_srcs = [
    "cnss_common/cnss_common.c",
    "main.c",
    "qmi/qmi.c",
    "bus/bus.c",
    "genl/genl.c",
    "qmi/cnss_plat_ipc_qmi.c",
    "ahb/ahb.c",
    "power.c",
    "wlan_firmware_service_v01.c",
    "cnss_plat_ipc_service_v01.c",
    "coredump.c"
]

_fixed_copts = [
    "-Wall",
    "-Werror",
    "-Wno-format-security",
    "-DCONFIG_CNSS_QCN9000",
    "-DCONFIG_CNSS2_GENL",
    "-Wno-unused-but-set-variable",
    "-Wimplicit-function-declaration",
    "-Wno-implicit-fallthrough",
]

def define_modules(target, variant):
    _defconfig = ":configs/{}_defconfig".format(variant)

    _name = "{}_{}_cnss_ko".format(target, variant)
    _out = "ipq_cnss2.ko"
    _kconfig = "Kconfig"

    _copts = []
    _srcs = []
    iglobs = []

    for i in _fixed_copts:
        _copts.append(i)

    _copts += ["-include", "$(location :cnss_config_headers)"]
    _srcs = native.glob(iglobs) + _fixed_srcs

    ddk_module(
        name=_name,
        out=_out,
        srcs=_srcs,
        kconfig=_kconfig,
        defconfig=_defconfig,
        conditional_srcs=_conditional_srcs,
        kernel_build = "//msm-kernel:{}_{}-defconfig".format(target,variant),
        copts=_copts,
        deps=[
            ":cnss_headers",
            "//msm-kernel:all_headers",
            ":cnss_config_headers",
        ]
    )
    mod_list=[]
    mod_list.append(_name)
    copy_to_dist_dir(
        name = "{}_{}-defconfig_cnss_dist".format(target, variant),
        data = mod_list,
        dist_dir = "out/target/product/{}/dlkm/lib/modules/".format(target),
        flat = True,
        wipe_dist_dir = False,
        allow_duplicate_filenames = False,
        mode_overrides = {"**/*": "644"},
        log = "info",
    )
