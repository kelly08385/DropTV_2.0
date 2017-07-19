# DropTV_2.0
# Requirement
*   Xcode 7.3+
*   Swift 2.2 (default version in Xcode 7.3)
*   [cocoaPods](https://cocoapods.org/)

# Setup
1. 選擇 clone or download --> download zip
2. 若還未安裝 cocoapods，請先在終端機輸入

    `sudo gem install cocoapods`
3. 終端機進入專案的資料夾，輸入`pod install`，會自動安裝需要的frameworks
4. 正確安裝後，即可雙擊`DropTV_2.0.xcworkspace`來開啟專案

# Q&A
1. 若在安裝frameworks過程中，不小心執行到`pod init`，使podfile初始化  
請編輯podfile如以下格式，並儲存，接下來執行`pod install`
  ```
  platform :ios, '8.0'
  use_frameworks!

  pod 'Moscapsule', :git => 'https://github.com/flightonary/Moscapsule.git'
  pod 'OpenSSL-Universal', '~> 1.0.1.18'
  pod 'Google/SignIn'
  pod 'SDWebImage', '~>3.8'
  ```
2. 若還是無法正確安裝，直接點擊以下連結來下載專案，並雙擊`DropTV_2.0.xcworkspace`來開啟專案  
[Drop_TV2.0](https://drive.google.com/drive/folders/0B3qPXYNaUSw5WUlmMm1RZkRDdWc?usp=sharing)
