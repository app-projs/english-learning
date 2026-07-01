from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
ICON = ROOT / "assets" / "brand" / "lumina_app_icon_1024.png"


def save_png(path: Path, size: int):
    path.parent.mkdir(parents=True, exist_ok=True)
    src = Image.open(ICON).convert("RGBA")
    src.resize((size, size), Image.Resampling.LANCZOS).save(path)


def main():
    android = {
        "mipmap-mdpi/ic_launcher.png": 48,
        "mipmap-hdpi/ic_launcher.png": 72,
        "mipmap-xhdpi/ic_launcher.png": 96,
        "mipmap-xxhdpi/ic_launcher.png": 144,
        "mipmap-xxxhdpi/ic_launcher.png": 192,
    }
    for rel, size in android.items():
        save_png(ROOT / "android" / "app" / "src" / "main" / "res" / rel, size)

    ios = {
        "Icon-App-20x20@1x.png": 20,
        "Icon-App-20x20@2x.png": 40,
        "Icon-App-20x20@3x.png": 60,
        "Icon-App-29x29@1x.png": 29,
        "Icon-App-29x29@2x.png": 58,
        "Icon-App-29x29@3x.png": 87,
        "Icon-App-40x40@1x.png": 40,
        "Icon-App-40x40@2x.png": 80,
        "Icon-App-40x40@3x.png": 120,
        "Icon-App-60x60@2x.png": 120,
        "Icon-App-60x60@3x.png": 180,
        "Icon-App-76x76@1x.png": 76,
        "Icon-App-76x76@2x.png": 152,
        "Icon-App-83.5x83.5@2x.png": 167,
        "Icon-App-1024x1024@1x.png": 1024,
    }
    ios_dir = ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    for name, size in ios.items():
        save_png(ios_dir / name, size)

    mac = {
        "app_icon_16.png": 16,
        "app_icon_32.png": 32,
        "app_icon_64.png": 64,
        "app_icon_128.png": 128,
        "app_icon_256.png": 256,
        "app_icon_512.png": 512,
        "app_icon_1024.png": 1024,
    }
    mac_dir = ROOT / "macos" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    for name, size in mac.items():
        save_png(mac_dir / name, size)

    web = {
        "favicon.png": 32,
        "icons/Icon-192.png": 192,
        "icons/Icon-maskable-192.png": 192,
        "icons/Icon-512.png": 512,
        "icons/Icon-maskable-512.png": 512,
    }
    for rel, size in web.items():
        save_png(ROOT / "web" / rel, size)

    ico_sizes = [16, 24, 32, 48, 64, 128, 256]
    src = Image.open(ICON).convert("RGBA")
    src.save(
        ROOT / "windows" / "runner" / "resources" / "app_icon.ico",
        sizes=[(size, size) for size in ico_sizes],
    )


if __name__ == "__main__":
    main()
