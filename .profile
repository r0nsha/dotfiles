if [ "$(uname -s)" = Linux ]; then
    # qt
    export QT_QPA_PLATFORMTHEME=qt6ct
    export QT_QPA_PLATFORM=wayland

    # firefox
    export MOZ_ENABLE_WAYLAND=1

    # electron
    export ELECTRON_OZONE_PLATFORM_HINT=auto

    # nvidia
    if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -L 2>/dev/null | grep -q '^GPU '; then
        export GBM_BACKEND=nvidia-drm
        export LIBVA_DRIVER_NAME=nvidia
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export MOZ_DISABLE_RDD_SANDBOX=1
        export MOZ_WAYLAND_USE_VAAPI=1
        export NVD_BACKEND=direct
        export __GL_GSYNC_ALLOWED=1
        export __GL_VRR_ALLOWED=1
        export WLR_SCENE_DISABLE_DIRECT_SCANOUT=1
        # equivalent of `sway --unsupported-gpu`, for the stock sway.desktop entry
        export SWAY_UNSUPPORTED_GPU=true
    fi
fi
