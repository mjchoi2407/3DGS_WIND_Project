#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$MainLanIp,
    [Parameter(Mandatory=$true)][string]$SubLanIp,
    [string]$Distro = 'Ubuntu'
)
$ErrorActionPreference = 'Stop'
foreach ($Value in @($MainLanIp, $SubLanIp)) {
    $Parsed = [System.Net.IPAddress]::Parse($Value)
    if ($Parsed.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork -or
        $Value -eq '0.0.0.0' -or $Value.StartsWith('127.')) {
        throw '유효한 LAN IPv4 주소가 필요합니다.'
    }
}
if ($MainLanIp -eq $SubLanIp) { throw '두 컴퓨터의 LAN IP가 같습니다.' }
$Address = Get-NetIPAddress -AddressFamily IPv4 -IPAddress $MainLanIp
if (-not $Address) { throw '이 컴퓨터에 메인 LAN IP가 없습니다.' }
$RuleName = 'Wind3DGS-SMB-In'
$Existing = Get-NetFirewallRule -Name $RuleName -ErrorAction SilentlyContinue
$RegistryKey = 'HKLM:\SYSTEM\CurrentControlSet\Services\PortProxy\v4tov4\tcp'
$Endpoint = "$MainLanIp/1445"
$Previous = Get-ItemPropertyValue -Path $RegistryKey -Name $Endpoint -ErrorAction SilentlyContinue
if ($Previous -and -not $Existing) {
    throw '기존 포트 전달의 소유권을 확인해야 합니다. 기존 항목은 변경하지 않았습니다.'
}
& wsl.exe -d $Distro -u root -- systemctl start smbd
if ($LASTEXITCODE -ne 0) { throw 'Samba 시작 실패' }
$RouteJson = & wsl.exe -d $Distro -- ip -j -4 route get 1.1.1.1
if ($LASTEXITCODE -ne 0) { throw 'WSL 경로 조회 실패' }
$Routes = $RouteJson | ConvertFrom-Json
$WslIp = [string]@($Routes)[0].prefsrc
$ParsedWslIp = [System.Net.IPAddress]::Parse($WslIp)
if ($ParsedWslIp.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
    throw 'WSL IPv4 확인 실패'
}
if (-not (Test-NetConnection $WslIp -Port 445 -InformationLevel Quiet -WarningAction SilentlyContinue)) {
    throw 'WSL Samba TCP 445에 연결할 수 없습니다.'
}
Start-Service iphlpsvc
& netsh interface portproxy add v4tov4 "listenaddress=$MainLanIp" listenport=1445 "connectaddress=$WslIp" connectport=445
if ($LASTEXITCODE -ne 0) { throw '포트 전달 등록 실패' }
# 네트워크 프로필은 변경하지 않는다. Public이어도 지정한 상대 IP/로컬 IP/포트만 허용한다.
if ($Existing) {
    Set-NetFirewallRule -Name $RuleName -Enabled True -Direction Inbound -Action Allow -Profile Any
    Get-NetFirewallRule -Name $RuleName | Get-NetFirewallAddressFilter |
        Set-NetFirewallAddressFilter -LocalAddress $MainLanIp -RemoteAddress $SubLanIp
    Get-NetFirewallRule -Name $RuleName | Get-NetFirewallPortFilter |
        Set-NetFirewallPortFilter -Protocol TCP -LocalPort 1445
} else {
    New-NetFirewallRule -Name $RuleName -DisplayName 'Wind3DGS SMB 지정 서브컴' -Direction Inbound -Action Allow -Protocol TCP -LocalAddress $MainLanIp -LocalPort 1445 -RemoteAddress $SubLanIp -Profile Any | Out-Null
}
Write-Output '메인컴 포트 전달 설정 완료. 서브컴에서 TCP 1445와 SMB 인증·읽기를 검증하세요.'
Write-Output 'WSL 재시작 후 IP가 바뀌면 같은 명령을 재실행하세요. 장기 계산은 시작하지 않았습니다.'
