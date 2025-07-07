import sys
import os
import ctypes
from PIL import Image, ImageDraw

def add_black_bar_lossless(input_path, bar_height=2):
    # Open original image and get ICC profile
    with open(input_path, 'rb') as f:
        img = Image.open(f)
        icc_profile = img.info.get('icc_profile')

        if img.mode not in ["RGB", "RGBA"]:
            img = img.convert("RGB")

        width, height = img.size
        draw = ImageDraw.Draw(img)
        draw.rectangle([0, height - bar_height, width, height], fill="black")

        # Generate output path
        base, ext = os.path.splitext(input_path)
        output_path = f"{base}_with_blackbar{ext}"

        save_kwargs = {"icc_profile": icc_profile} if icc_profile else {}

        if img.format == "JPEG":
            save_kwargs.update({
                "format": "JPEG",
                "quality": 100,
                "subsampling": 0,
                "optimize": False
            })
        elif img.format == "PNG":
            save_kwargs.update({
                "format": "PNG",
                "compress_level": 0
            })
        else:
            save_kwargs["format"] = img.format

        img.save(output_path, **save_kwargs)
        print(f"✅ Saved modified wallpaper: {output_path}")
        return output_path

def set_wallpaper(image_path):
    # SPI_SETDESKWALLPAPER = 20
    result = ctypes.windll.user32.SystemParametersInfoW(20, 0, image_path, 3)
    if result:
        print(f"🖼️  Wallpaper successfully set to: {image_path}")
    else:
        print("❌ Failed to set wallpaper.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python add_black_bar.py path/to/image.jpg")
        sys.exit(1)

    input_file = sys.argv[1]
    if not os.path.isfile(input_file):
        print(f"❌ File not found: {input_file}")
        sys.exit(1)

    output_file = add_black_bar_lossless(input_file)
    set_wallpaper(output_file)
