from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs" / "stitch_exports" / "logo.png"
OUT = ROOT / "assets" / "brand"

FONT_LATIN = "/System/Library/Fonts/Avenir.ttc"
FONT_LATIN_FALLBACK = "/System/Library/Fonts/HelveticaNeue.ttc"
FONT_CJK = "/System/Library/AssetsV2/com_apple_MobileAsset_Font8/86ba2c91f017a3749571a82f2c6d890ac7ffb2fb.asset/AssetData/PingFang.ttc"
FONT_CJK_FALLBACK = "/System/Library/Fonts/Supplemental/Arial Unicode.ttf"


def font(path: str, size: int, fallback: str | None = None) -> ImageFont.FreeTypeFont:
    try:
        return ImageFont.truetype(path, size=size)
    except OSError:
        if fallback:
            return ImageFont.truetype(fallback, size=size)
        raise


def resize_square(img: Image.Image, size: int) -> Image.Image:
    return img.resize((size, size), Image.Resampling.LANCZOS)


def remove_soft_background(img: Image.Image) -> Image.Image:
    img = img.convert("RGBA")
    px = img.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = px[x, y]
            # The source board is near-white; fade it out but keep pale logo strokes.
            whiteness = min(r, g, b)
            if whiteness > 244 and max(r, g, b) - min(r, g, b) < 12:
                px[x, y] = (255, 255, 255, 0)
            elif whiteness > 236:
                px[x, y] = (r, g, b, int(a * 0.45))
    return img


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    source = Image.open(SOURCE).convert("RGBA")

    # Extract the real top-left app icon from the supplied brand board.
    icon = source.crop((178, 270, 653, 745))
    for size in (1024, 512, 192):
        resize_square(icon, size).save(OUT / f"lumina_app_icon_{size}.png")

    # Extract the original logo mark from the source board and make a transparent version.
    mark = source.crop((928, 884, 1194, 1168))
    mark = remove_soft_background(mark)
    mark.resize((1024, 1093), Image.Resampling.LANCZOS).save(OUT / "lumina_logo_mark.png")

    # Build a corrected lockup with the requested English and Chinese names.
    # The supplied board already has the right icon, wordmark, curve, glow, and
    # Chinese name. Keep that original block intact and add "English" outside it.
    canvas = Image.new("RGBA", (1800, 720), (255, 253, 251, 255))
    original_lockup = source.crop((120, 250, 1505, 790))
    original_lockup = original_lockup.resize((1385, 540), Image.Resampling.LANCZOS)
    canvas.alpha_composite(original_lockup, (92, 88))
    latin_small = font(FONT_LATIN, 58, FONT_LATIN_FALLBACK)
    draw = ImageDraw.Draw(canvas)
    draw.text((1490, 312), "English", font=latin_small, fill=(52, 73, 94, 228))

    canvas.save(OUT / "lumina_brand_lockup.png")


if __name__ == "__main__":
    main()
