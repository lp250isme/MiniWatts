# MiniWatts

[English](README.md) · [简体中文](README.zh-Hans.md) · **正體中文**

[![Build](https://github.com/lp250isme/MiniWatts/actions/workflows/build.yml/badge.svg)](https://github.com/lp250isme/MiniWatts/actions/workflows/build.yml)

> 這是 [ResistanceTo/MiniWatts](https://github.com/ResistanceTo/MiniWatts) 的正體中文分支，授權 Apache 2.0。介面、小工具與即時動態都是正體中文。上游著作權仍屬 ZhaoHe Studio，變更說明見 [NOTICE](NOTICE)。

用 Apple 私有 API 做的 iPhone 電池與充電資訊 App。它讀取手機自己的電源管理感測器——也就是 iOS 用來控制充電的那一套——顯示充電器正在輸出多少、其中有多少真正進到電芯、剩下的變成多少熱，以及這段時間手機裡每一顆溫度感測器的讀數。

| 功率 | 溫度 | 轉接器 | 歷史 |
|:-:|:-:|:-:|:-:|
| <img src="docs/screenshots/power.jpg" width="200" alt="功率"> | <img src="docs/screenshots/thermal.jpg" width="200" alt="溫度"> | <img src="docs/screenshots/adapter.jpg" width="200" alt="轉接器"> | <img src="docs/screenshots/history.jpg" width="200" alt="歷史"> |

> **只能自行簽名安裝。** 用了私有 API，所以無法上架 App Store，需要自己簽名安裝。沒有任何網路程式碼：讀到的資料不會離開這支手機。

## 安裝

從 [Releases](https://github.com/lp250isme/MiniWatts/releases) 下載最新的
`MiniWatts-unsigned.ipa`，用你自己的 Apple ID 簽名安裝——[Sideloadly](https://sideloadly.io)、
[AltStore](https://altstore.io)、[SideStore](https://sidestore.io) 和 Xcode 都可以。
免費 Apple ID 可以用，但 App 會在 7 天後過期，需要重新簽名。

需要 iPhone，iOS 17 或更新版本。

也可以把這個來源加到 SideStore 或 AltStore（含 LiveContainer 附帶的 SideStore），從來源安裝，之後的新版本會以更新出現：

```
https://github.com/lp250isme/MiniWatts/releases/latest/download/apps.json
```

LiveContainer 無法執行 App Extension，所以裝在 LiveContainer 裡的 MiniWatts 沒有小工具，也沒有即時動態。

MiniWatts 有主畫面與鎖定畫面小工具，以及充電時的即時動態。簽名時小工具 Extension 會多佔一個 App ID——免費 Apple ID 每週只能註冊 10 個。如果簽名工具提議移除 Extension，移除後就沒有小工具。

## 它做不到的事

感測器的名稱、換算方式，甚至有沒有這個感測器，都因 iPhone 機型而異，而且沒有官方文件。這個版本在 iPhone Air 上開發與驗證。換一個機型，某項讀數可能不存在，也可能名稱和實際含義對不上。不可能出現的數值——例如真的有人看到充電晶片顯示 −9199 °C——會被隱藏，不會顯示出來。但一個看起來合理、其實是錯的數值，用這個方法擋不住。若看到異常數字，請附上機型識別碼回報。

只能顯示 iOS 真正交給沙盒 App 的資料。電池健康度與循環次數會被濾掉；配件電量（Watch、AirPods）回來是空的；無線充電不會提供輸入電流，所以用 MagSafe 時只能看到進到電芯的部分；放電功率沒有對應感測器，只能用電量百分比估算。充電暫停只能從行為推斷，推斷出來的會標成「推斷」。

小工具何時重新整理由 iOS 決定，通常每 15 到 60 分鐘一次，每個小工具都會標明資料的讀取時間。即時動態只在 MiniWatts 執行時更新；App 被系統暫停後會顯示為已暫停。這兩樣都做不到每秒更新——次數由系統分配，App 無法決定。

想在別的 App 裡也看到每秒變化的讀數，可以在設定裡開啟浮動讀數：一個子母畫面小窗。開著的時候 MiniWatts 會一直執行，所以鎖定後也能繼續記錄這次充電。代價是更耗電，用完要自己關掉。它不播放任何聲音——子母畫面本來是影片功能，App 宣告音訊播放能力只是為了這個。

## 建置

Xcode 26 或更新版本，iOS 17 deployment target，沒有第三方依賴。

```bash
./scripts/build-ipa.sh                             # 不簽名，Releases 發布的就是這個
TEAM_ID=ABCDE12345 ./scripts/build-ipa.sh signed   # 簽名，裝到自己的裝置
```

[`CLAUDE.md`](CLAUDE.md) 是這個專案的工程筆記：沙盒擋住了哪些 API、結論怎麼驗證、每個感測器最後查到是什麼，以及這個專案已經踩過的 Swift 6 isolation 陷阱。

## 授權

Apache 2.0，見 [LICENSE](LICENSE)。讀取 PMU 的方法衍生自
[ios-charging-monitor](https://github.com/gregsramblings/ios-charging-monitor)（MIT），
`BatteryCenterBridge` 有兩處細節參考自 [Batsie](https://github.com/leptos-null/Batsie)。
兩者都記在 [NOTICE](NOTICE)，上游的 MIT 聲明也逐字留在那裡。

私有 API 可能在任何一次 iOS 更新裡改變或消失。
