"""
CSV 数据分析小工具
CSV Analyzer — 丢一个表格文件进来，自动告诉你里面有什么

场景：老板给了你一个 Excel 导出的 CSV 文件，让你"看看数据"。
你打开一看，几千行，眼睛都花了。
这个脚本帮你快速摸清数据的底细。
"""

import csv
import os
from collections import Counter


def analyze_csv(filepath):
    """读取 CSV 文件，给你一份体检报告"""

    # 读文件（encoding 试两种常见的）
    for encoding in ["utf-8", "gbk", "latin-1"]:
        try:
            with open(filepath, "r", encoding=encoding) as f:
                reader = csv.DictReader(f)
                rows = list(reader)
                headers = reader.fieldnames
            break
        except (UnicodeDecodeError, Exception):
            continue
    else:
        print("  文件编码我认不出来，换个文件试试？")
        return

    if not rows:
        print("  文件是空的呀")
        return

    # 开始分析
    print(f"\n{'=' * 50}")
    print(f"  (=^・ω・^=)  数据体检报告")
    print(f"{'=' * 50}\n")

    print(f"  文件：{os.path.basename(filepath)}")
    print(f"  总行数：{len(rows)} 行")
    print(f"  总列数：{len(headers)} 列")

    # 每一列的信息
    print(f"\n  {'─' * 46}")
    print(f"  各列概况：\n")

    for header in headers:
        values = [row.get(header, "").strip() for row in rows]
        non_empty = [v for v in values if v]
        unique_count = len(set(non_empty))

        print(f"  【{header}】")
        print(f"    有内容：{len(non_empty)} / {len(rows)}")
        print(f"    不重复值：{unique_count} 个")

        # 如果不重复值不多，显示前几个最常见的
        if 0 < unique_count <= 20:
            counter = Counter(non_empty).most_common(5)
            top_items = ", ".join([f"{v}({c}次)" for v, c in counter])
            print(f"    常见值：{top_items}")

        # 试试看是不是数字列
        numbers = []
        for v in non_empty:
            try:
                numbers.append(float(v.replace(",", "")))
            except ValueError:
                pass

        if len(numbers) > len(non_empty) * 0.8:  # 80% 以上是数字就算数字列
            avg = sum(numbers) / len(numbers)
            print(f"    数值范围：{min(numbers):.1f} ~ {max(numbers):.1f}")
            print(f"    平均值：{avg:.1f}")

        print()

    print(f"{'=' * 50}")
    print(f"  看吧，数据没那么可怕，就是些行和列。")
    print(f"{'=' * 50}\n")


def main():
    print("\n  (=^・ω・^=)  CSV 数据分析")
    print("  把 CSV 文件拖进来，我帮你看看里面有什么\n")

    filepath = input("  文件路径 > ").strip().strip("'\"")

    if not os.path.isfile(filepath):
        print("  这个文件找不到，路径对吗？")
        return

    if not filepath.lower().endswith(".csv"):
        print("  这好像不是 CSV 文件？我只认 .csv 结尾的")
        return

    analyze_csv(filepath)


if __name__ == "__main__":
    main()
