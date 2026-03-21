"""
批量文件改名工具
Batch File Renamer — 一键给文件夹里的文件统一改名

场景：你拍了一堆照片叫 IMG_0001.jpg、IMG_0002.jpg...
想改成 旅行-001.jpg、旅行-002.jpg...
手动改要改到天荒地老，这个脚本帮你一键搞定。
"""

import os
import sys


def preview_rename(folder, prefix, start_num=1):
    """
    先看看改完会变成什么样，不真的改
    就像装修前先看效果图
    """
    files = sorted(os.listdir(folder))
    # 过滤掉隐藏文件（.开头的）和文件夹
    files = [f for f in files if not f.startswith(".") and os.path.isfile(os.path.join(folder, f))]

    if not files:
        print("  这个文件夹里没有文件呀")
        return []

    changes = []
    for i, old_name in enumerate(files, start_num):
        # 拿到文件后缀名（.jpg、.png 这种）
        _, ext = os.path.splitext(old_name)
        new_name = f"{prefix}-{i:03d}{ext}"
        changes.append((old_name, new_name))

    return changes


def do_rename(folder, changes):
    """真的改名字"""
    success = 0
    for old_name, new_name in changes:
        old_path = os.path.join(folder, old_name)
        new_path = os.path.join(folder, new_name)
        try:
            os.rename(old_path, new_path)
            success += 1
        except Exception as e:
            print(f"  改名失败：{old_name} → {e}")

    return success


def main():
    print("\n  (=^・ω・^=)  批量改名工具")
    print("  把文件夹里的文件统一改个名字\n")

    # 让用户输入文件夹路径
    folder = input("  文件夹路径（直接把文件夹拖进来就行）> ").strip().strip("'\"")

    if not os.path.isdir(folder):
        print("  这个路径不对，再检查一下？")
        return

    # 让用户输入想要的前缀
    prefix = input("  想改成什么开头？比如'旅行'、'会议'、'截图' > ").strip()

    if not prefix:
        print("  你啥也没输入呀")
        return

    # 先预览
    changes = preview_rename(folder, prefix)

    if not changes:
        return

    print(f"\n  预览（共 {len(changes)} 个文件）：\n")
    for old, new in changes[:10]:  # 最多显示10个
        print(f"    {old}  →  {new}")

    if len(changes) > 10:
        print(f"    ... 还有 {len(changes) - 10} 个")

    print()
    confirm = input("  确认改名？(y/n) > ").strip().lower()

    if confirm == "y":
        count = do_rename(folder, changes)
        print(f"\n  搞定了，改了 {count} 个文件 (^・ω・^)")
        print("  熟能生巧，下次你就熟练了。\n")
    else:
        print("\n  取消了，文件原封不动 (=^・^=)\n")


if __name__ == "__main__":
    main()
