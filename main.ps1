$domain = "https://api.neos.com/api"

function Search_User(){
  $target;
  $count;
  $username = Read-Host "ユーザ名を入力 ";
  $result = Invoke-WebRequest "${domain}/users?name=${username}";
  $result.Content | ConvertFrom-Json | %{
    Write-Host $_.id "("$_.username")";
    $target = $_;
    $count++;
  }
  if ($count -eq 1){
    $target.id >> .\userList.txt;
    Write-Host $target.username "をリストに追加しました";
  }elseif ($count -gt 1){
    Write-Host "複数のユーザがヒットしました";
    Write-Host "U-xxxxx のように入力して追加するユーザを特定します";
    $userid = Read-Host "IDを入力 ";
    if ($(Invoke-WebRequest "${domain}/users/${userid}").StatusCode -eq 200){
      $userid >> .\userList.txt
      Write-Host $userid "をリストに追加しました"
    }else{
      Write-Host "IDが間違っています。もう一度最初からやり直してください。"
    }
  }else{
    Write-Host "見つかりませんでした"
  }
}

function Get_Status(){
  Get-Content ./userList.txt | %{
    $userid = $_;
    $result = Invoke-WebRequest "${domain}/users/${userid}/status";
    $result.Content | ConvertFrom-Json | %{
      $status = $_
      Write-Host $userid -NoNewline
      Switch($status.onlineStatus){
        "Offline"{
          $color = 'DarkGray'
        }
        "Online"{
          $color = 'Green'
        }
        "Away"{
          $color = 'Orange'
        }
        "Busy"{
          $color = 'Red'
        }
        "Invisible"{
          $color = 'DarkRed'
        }
      }
      Write-Host "" $status.onlineStatus -ForegroundColor $color;
      if( $status.onlineStatus -ne "Offline" -and $status.activeSessions ){
        if ($status.outputDevice -eq 'VR'){ Write-Host "VRでログイン中" }
        if ($status.outputDevice -eq 'Headless'){ Write-Host "Headlessサーバとしてログイン中" }
        $status.activeSessions | %{
          $session = $_;
          Write-Host " " $_.name "にいます";
          Write-Host "   [セッション内のユーザ一覧]";
          $_.sessionUsers | %{
            $color = 'White';
            if ( $session.hostUserId -eq $_.userID ) { $color = 'Yellow' };
            Write-Host "    -" $_.username -ForegroundColor $color;
          }
        }
      }else{
        Write-Host "[最終オンライン]" $status.laststatuschange.AddHours(9).ToString("MM/dd HH:mm");
      }
    }
    Write-Host
  }
}

function Help(){
  "add ユーザを検索します";
  "sta オンラインステータスを取得します";
}

### Main
if (Test-Path ./userList.txt ) {
  Get_Status
}else{
  Help
}

While ($True){
  "";
  $command = Read-Host "Command ";
  switch($command){
    "help" {
      Help;
    }
    "add" {
      Search_User;
    }
    "sta" {
      Get_Status;
    }
    default {
      Help;
    }
  }
}
