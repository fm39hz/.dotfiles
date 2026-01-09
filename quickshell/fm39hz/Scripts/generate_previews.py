
import os
import sys
import argparse
import subprocess
from concurrent.futures import ThreadPoolExecutor

def generate_thumbnail(args):
    src, dest = args
    if os.path.exists(dest):
        return # Skip if exists
        
    try:
        # Resize to 600x400, covering the area (^) and cropping to center
        # This matches the aspect ratio of the grid cells roughly but with higher quality
        cmd = [
            "convert",
            src,
            "-resize", "600x400^",
            "-gravity", "center",
            "-extent", "600x400",
            dest
        ]
        subprocess.run(cmd, check=True, stderr=subprocess.DEVNULL)
        print(f"Generated: {dest}")
    except Exception as e:
        print(f"Failed to generate {src}: {e}")

def main():
    parser = argparse.ArgumentParser(description="Generate wallpaper thumbnails")
    parser.add_argument("input_dir", help="Directory containing wallpapers")
    parser.add_argument("output_dir", help="Directory to save thumbnails")
    args = parser.parse_args()

    if not os.path.exists(args.output_dir):
        os.makedirs(args.output_dir, exist_ok=True)

    files = []
    valid_exts = {".jpg", ".jpeg", ".png", ".webp", ".bmp"}
    
    for filename in os.listdir(args.input_dir):
        ext = os.path.splitext(filename)[1].lower()
        if ext in valid_exts:
            src = os.path.join(args.input_dir, filename)
            dest = os.path.join(args.output_dir, filename)
            files.append((src, dest))

    # Use ThreadPoolExecutor for parallelism
    # 'convert' is CPU/IO bound, so a pool helps
    with ThreadPoolExecutor(max_workers=4) as executor:
        executor.map(generate_thumbnail, files)
        
    print(f"Processed {len(files)} wallpapers.")

if __name__ == "__main__":
    main()
