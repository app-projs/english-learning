from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
ICON = ROOT / "assets" / "brand" / "lumina_app_icon_1024.png"

FONT_LATIN = "/System/Library/Fonts/Avenir.ttc"
FONT_LATIN_FALLBACK = "/System/Library/Fonts/HelveticaNeue.ttc"
FONT_CJK = "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/86ba2c91f017a3749571a82f2c6d890ac7ffb2fb.asset/AssetData/PingFang.ttc"
FONT_CJK_FALLBACK = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"


def font(path: str, size: int, fallback: str) -> ImageFont.FreeTypeFont:
    try:
        return ImageFont.truetype(path, size=size)
    except OSError:
        return ImageFont.truetype(fallback, size=size)


def rounded_mask(size: int, radius: int) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, size, size), radius=radius, fill=255)
    return mask


def centered_text(draw: ImageDraw.ImageDraw, text: str, y: int, fnt: ImageFont.FreeTypeFont, fill, canvas_w: int):
    bbox = draw.textbbox((0, 0), text, font=fnt)
    x = (canvas_w - (bbox[2] - bbox[0])) // 2
    draw.text((x, y), text, font=fnt, fill=fill)


def make_launch_image(scale: int) -> Image.Image:
    canvas_w, canvas_h = 240 * scale, 300 * scale
    icon_size = 128 * scale
    icon_radius = 34 * scale
    icon_x = (canvas_w - icon_size) // 2
    icon_y = 28 * scale

    canvas = Image.new("RGBA", (canvas_w, canvas_h), (255, 255, 255, 255))
    icon = Image.open(ICON).convert("RGBA").resize((icon_size, icon_size), Image.Resampling.LANCZOS)
    mask = rounded_mask(icon_size, icon_radius)
    icon.putalpha(mask)

    shadow_pad = 34 * scale
    shadow_size = icon_size + shadow_pad * 2
    shadow_alpha = Image.new("L", (shadow_size, shadow_size), 0)
    shadow_draw = ImageDraw.Draw(shadow_alpha)
    shadow_draw.rounded_rectangle(
        (shadow_pad, shadow_pad, shadow_pad + icon_size, shadow_pad + icon_size),
        radius=icon_radius,
        fill=255,
    )
    shadow_alpha = shadow_alpha.filter(ImageFilter.GaussianBlur(18 * scale))
    shadow_alpha = shadow_alpha.point(lambda v: int(v * 0.14))
    shadow = Image.new("RGBA", (shadow_size, shadow_size), (72, 88, 120, 0))
    shadow.putalpha(shadow_alpha)
    canvas.alpha_composite(shadow, (icon_x - shadow_pad, icon_y - shadow_pad + 14 * scale))
    canvas.alpha_composite(icon, (icon_x, icon_y))

    draw = ImageDraw.Draw(canvas)
    latin = font(FONT_LATIN, 23 * scale, FONT_LATIN_FALLBACK)
    cjk = font(FONT_CJK, 18 * scale, FONT_CJK_FALLBACK)
    centered_text(draw, "lumina English", 178 * scale, latin, (70, 86, 112, 235), canvas_w)
    centered_text(draw, "露米娜英语", 214 * scale, cjk, (70, 86, 112, 205), canvas_w)
    return canvas


def save_ios():
    out = ROOT / "ios" / "Runner" / "Assets.xcassets" / "LaunchImage.imageset"
    make_launch_image(1).save(out / "LaunchImage.png")
    make_launch_image(2).save(out / "LaunchImage@2x.png")
    make_launch_image(3).save(out / "LaunchImage@3x.png")


def save_android():
    densities = {
        "mipmap-mdpi": 1,
        "mipmap-hdpi": 1.5,
        "mipmap-xhdpi": 2,
        "mipmap-xxhdpi": 3,
        "mipmap-xxxhdpi": 4,
    }
    base = make_launch_image(4)
    for folder, scale in densities.items():
        w, h = int(240 * scale), int(300 * scale)
        img = base.resize((w, h), Image.Resampling.LANCZOS)
        img.save(ROOT / "android" / "app" / "src" / "main" / "res" / folder / "launch_image.png")


if __name__ == "__main__":
    save_ios()
    save_android()
