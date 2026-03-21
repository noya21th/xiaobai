"""
图片批量缩放工具
Image Resizer — 一键把文件夹里的图片统一缩小

场景：你有一堆手机拍的照片，每张好几 MB。
想发给别人或者上传到网站，太大了传不动。
这个脚本帮你一键全部缩小。

需要安装 Pillow：pip install Pillow
"""

import os
import sys

try:
    from PIL import Image
except ImportError:
    print("\n  需要先装一个工具。复制下面 👇 这行，粘贴到终端里按回车：")
    print("\n  pip install Pillow\n")
    print("  装好了再运行这个脚本 (=^・^=)\n")
    sys.exit(1)


def resize_image(input_path, output_path, max_size=1920):
    """
    缩小一张图片
    max_size 是最长边的像素数，默认 1920（全高清）
    """
    img = Image.open(input_path)
    width, height = img.size

    # 如果图片已经够小了就不缩
    if width <= max_size and height <= max_size:
        return False, img.size, img.size

    # 算出缩放比例（保持长宽比，不变形）
    ratio = min(max_size / width, max_size / height)
    new_width = int(width * ratio)
    new_height = int(height * ratio)

    # 缩放并保存
    img_resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    img_resized.save(output_path, quality=85, optimize=True)

    return True, (width, height), (new_width, new_height)


def format_size(size_bytes):
    """把文件大小变成人能读的格式"""
    if size_bytes < 1024:
        return f"{size_bytes} B"
    elif size_bytes < 1024 * 1024:
        return f"{size_bytes / 1024:.1f} KB"
    else:
        return f"{size_bytes / (1024 * 1024):.1f} MB"


def main():
    print("\n  (=^・ω・^=)  图片批量缩放")
    print("  把大图变小图，方便传输和上传\n")

    # 输入文件夹
    folder = input("  图片文件夹路径（拖进来就行）> ").strip().strip("'\"")

    if not os.path.isdir(folder):
        print("  这个路径不对，再看看？")
        return

    # 最大尺寸
    size_input = input("  最长边缩到多少像素？（直接回车默认 1920）> ").strip()
    max_size = int(size_input) if size_input.isdigit() else 1920

    # 找出所有图片
    image_extensions = {".jpg", ".jpeg", ".png", ".webp", ".bmp"}
    images = []
    for f in sorted(os.listdir(folder)):
        ext = os.path.splitext(f)[1].lower()
        if ext in image_extensions:
            images.append(f)

    if not images:
        print("  这个文件夹里没有图片文件呀")
        return

    # 创建输出目录
    output_dir = os.path.join(folder, "resized")
    os.makedirs(output_dir, exist_ok=True)

    print(f"\n  找到 {len(images)} 张图片，开始缩放...\n")

    resized_count = 0
    total_saved = 0

    for filename in images:
        input_path = os.path.join(folder, filename)
        output_path = os.path.join(output_dir, filename)

        original_size = os.path.getsize(input_path)

        changed, old_dim, new_dim = resize_image(input_path, output_path, max_size)

        if changed:
            new_size = os.path.getsize(output_path)
            saved = original_size - new_size
            total_saved += saved
            resized_count += 1
            print(f"  ✓ {filename}")
            print(f"    {old_dim[0]}×{old_dim[1]} → {new_dim[0]}×{new_dim[1]}  "
                  f"({format_size(original_size)} → {format_size(new_size)})")
        else:
            # 已经够小了，直接复制过去
            img = Image.open(input_path)
            img.save(output_path, quality=85, optimize=True)
            print(f"  - {filename}（已经够小了，跳过）")

    print(f"\n  {'─' * 40}")
    print(f"  搞定了 (^・ω・^)")
    print(f"  缩放了 {resized_count} 张，节省了 {format_size(total_saved)}")
    print(f"  输出目录：{output_dir}")
    print(f"\n  工欲善其事，必先利其器。这个工具以后还能用。\n")


if __name__ == "__main__":
    main()
