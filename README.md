# neos-online-checker

## 使い方
1. [ダウンロードする](https://github.com/sweshelo/neos-online-checker/archive/refs/heads/master.zip)
2. ダウンロードしたフォルダを展開する
3. フォルダ内の何もないところでShift+右クリック「Windows PowerShellをここで開く」をクリックする
![image](https://user-images.githubusercontent.com/75022007/206988854-230c0183-b622-4092-8904-56fad16a369e.png)


4. 以下を入力する
```
.\main.ps1
```

以後、
- `add`を入力するとユーザ名を聞かれるので、入力してリスト追加
- `sta`を入力するとリストに追加済みのユーザステータス取得

## エラーが出た場合
```
.\main.ps1: File main.ps1 cannot be loaded.
The file main.ps1 is not digitally signed. You cannot run this script on the current system. For more information about running scripts and setting execution policy, see about_Execution_Policies at https://go.microsoft.com/fwlink/?LinkID=135170.
```
上記のエラーが出た場合は、以下のコマンドで一時的に実行制限を緩和させる。
```
set-executionPolicy Bypass -Scope Process
```
