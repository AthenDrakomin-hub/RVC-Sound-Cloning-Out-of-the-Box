#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import argparse
from infer.modules.vc.modules import VC
from configs.config import Config

def main():
    print("RVC 音色克隆 - 纯命令行版本")
    print("=" * 50)
    
    # 初始化配置
    config = Config()
    vc = VC(config)
    
    print("✅ 系统初始化完成")
    print("\n核心功能:")
    print("1. 实时音色克隆通话")
    print("2. 音频文件音色克隆")
    print("3. 训练新音色模型")
    print("4. 退出")
    
    while True:
        try:
            choice = input("\n请选择功能 (1-4): ").strip()
            
            if choice == "1":
                print("正在启动实时音色克隆通话...")
                # 启动实时音色克隆GUI
                os.system("python gui_v1.py")
                
            elif choice == "2":
                print("音频文件音色克隆需要使用Web界面，请运行启动应用程序.bat并选择相应选项")
                
            elif choice == "3":
                print("训练新音色模型需要使用Web界面，请运行启动应用程序.bat并选择相应选项")
                
            elif choice == "4":
                print("感谢使用RVC音色克隆系统！")
                break
                
            else:
                print("❌ 无效选项，请重新选择")
                
        except KeyboardInterrupt:
            print("\n\n程序已退出")
            break
        except Exception as e:
            print(f"❌ 发生错误: {str(e)}")

if __name__ == "__main__":
    main()