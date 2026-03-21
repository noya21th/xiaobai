"""
小白的天气查询工具
My First Weather App — 输入城市名，告诉你现在的天气

用到的知识点（你不用提前学，看注释就懂）：
- requests：让程序访问网页
- json：处理数据格式
- input()：让用户输入东西
"""

import requests
import json

def get_weather(city):
    """
    去网上查某个城市的天气
    用的是一个免费的天气接口，不用注册
    """
    # wttr.in 是一个免费天气服务，直接拼上城市名就能用
    url = f"https://wttr.in/{city}?format=j1"

    try:
        response = requests.get(url, timeout=10)
        data = response.json()

        # 从返回的数据里挑出我们要的信息
        current = data["current_condition"][0]

        temp = current["temp_C"]                    # 温度（摄氏度）
        feels_like = current["FeelsLikeC"]          # 体感温度
        humidity = current["humidity"]               # 湿度
        desc = current["lang_zh"][0]["value"]        # 天气描述（中文）
        wind = current["windspeedKmph"]              # 风速

        return {
            "城市": city,
            "天气": desc,
            "温度": f"{temp}°C",
            "体感": f"{feels_like}°C",
            "湿度": f"{humidity}%",
            "风速": f"{wind} km/h",
        }

    except requests.exceptions.Timeout:
        return {"错误": "网络超时了，等一下再试试"}
    except Exception as e:
        return {"错误": f"出了点问题：{e}"}


def display_weather(info):
    """把天气信息漂漂亮亮地打印出来"""
    print("\n" + "=" * 36)
    print(f"  (=^・ω・^=)  天气播报")
    print("=" * 36)

    for key, value in info.items():
        print(f"  {key}：{value}")

    print("=" * 36)
    print()


def main():
    print("\n  (=^・ω・^=)  小白天气查询")
    print("  输入城市名（英文），比如 Beijing、Tokyo、London")
    print("  输入 q 退出\n")

    while True:
        city = input("  查哪个城市？ > ").strip()

        if city.lower() == "q":
            print("\n  下次见 (=^・^=)\n")
            break

        if not city:
            print("  你啥也没输入呀，再来一次")
            continue

        print(f"  正在查 {city} 的天气...")
        info = get_weather(city)
        display_weather(info)


if __name__ == "__main__":
    main()
