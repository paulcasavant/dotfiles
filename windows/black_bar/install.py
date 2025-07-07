import os
import sys
import winreg
import argparse

# === CONFIGURATION ===
PYTHON_SCRIPT_PATH = os.path.abspath("add_black_bar.py")
BAT_WRAPPER_PATH = os.path.expandvars(r"%APPDATA%\SetBlackBar\set_blackbar_wallpaper.bat")
FILE_EXTENSIONS = [".jpg", ".png"]

def create_bat_wrapper():
    os.makedirs(os.path.dirname(BAT_WRAPPER_PATH), exist_ok=True)
    with open(BAT_WRAPPER_PATH, "w") as f:
        f.write(f"""@echo off
python "{PYTHON_SCRIPT_PATH}" "%~1"
""")
    print(f"✅ Created wrapper BAT file at:\n  {BAT_WRAPPER_PATH}")

def add_context_menu(extension):
    base_key = fr"Software\Classes\SystemFileAssociations\{extension}\shell\SetBlackBarWallpaper"
    command_key = base_key + r"\command"
    try:
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, base_key) as key:
            winreg.SetValueEx(key, "", 0, winreg.REG_SZ, "Set as desktop background with black bar")
            winreg.SetValueEx(key, "Icon", 0, winreg.REG_SZ, r"C:\Windows\System32\shell32.dll,137")
        with winreg.CreateKey(winreg.HKEY_CURRENT_USER, command_key) as cmd_key:
            winreg.SetValueEx(cmd_key, "", 0, winreg.REG_SZ, f'"{BAT_WRAPPER_PATH}" "%1"')
        print(f"✅ Context menu added for {extension}")
    except PermissionError:
        print(f"❌ Failed to add context menu for {extension} (registry access denied)")

def remove_context_menu(extension):
    key_path = fr"Software\Classes\SystemFileAssociations\{extension}\shell\SetBlackBarWallpaper"
    try:
        winreg.DeleteKey(winreg.HKEY_CURRENT_USER, key_path + r"\command")
        winreg.DeleteKey(winreg.HKEY_CURRENT_USER, key_path)
        print(f"🗑️  Removed context menu for {extension}")
    except FileNotFoundError:
        print(f"⚠️ No entry found for {extension}")
    except PermissionError:
        print(f"❌ Permission denied while deleting {extension}")

def main():
    parser = argparse.ArgumentParser(description="Setup or remove right-click 'Add black bar + Set wallpaper' context menu.")
    parser.add_argument("-d", "--delete", action="store_true", help="Remove the context menu instead of adding it")
    args = parser.parse_args()

    if args.delete:
        for ext in FILE_EXTENSIONS:
            remove_context_menu(ext)
        if os.path.exists(BAT_WRAPPER_PATH):
            os.remove(BAT_WRAPPER_PATH)
            print(f"🗑️  Removed wrapper BAT file: {BAT_WRAPPER_PATH}")
    else:
        if not os.path.isfile(PYTHON_SCRIPT_PATH):
            print(f"❌ Cannot find Python script at:\n  {PYTHON_SCRIPT_PATH}")
            sys.exit(1)
        create_bat_wrapper()
        for ext in FILE_EXTENSIONS:
            add_context_menu(ext)
        print("\n🎉 Setup complete. Right-click any JPG or PNG → Show more options → 🖼️  Add black bar + Set as Wallpaper")

if __name__ == "__main__":
    main()
