# 메인컴 Codex용: Windows 10·WSL2 프로젝트 공유

작성 기준: 2026-09-12. 일반 설정 절차다. **이 메인컴에 적용한 결과와 남은 작업은 [현재 상태](main_pc_status.md)를 먼저 확인한다.**
대상은 같은 공유기에 연결된 Windows 10 컴퓨터 두 대이며, 원본 프로젝트는 메인컴 WSL2 내부에 있다.
서브컴 절차는 [sub_pc_setup.md](sub_pc_setup.md)를 함께 전달한다. 두 파일만 먼저 전달하면 이후 코드는 공유 경로에서 읽는다.

## Codex에게 줄 작업 지시

> 이 문서를 따라 이 컴퓨터를 Wind3DGS의 파일 서버와 원격 제어 클라이언트로 설정해줘.
> 실제 환경을 먼저 조회하고 기존 설정을 보존하면서 필요한 변경과 짧은 검증을 수행해줘.
> 다른 컴퓨터에서 해야 하는 단계는 인계해줘. 관리자 권한이 없는 단계는 실행 가능한 명령으로 제공해줘.
> 진행 중 시뮬레이션을 중단하거나 WSL을 재시작하지 말고, 장기 시뮬레이션·commit·push는 실행하지 마.

이 지시는 **이 문서를 실행하도록 요청받은 후**의 범위다. 문서를 읽는 것만으로 시스템 변경을 시작하지 않는다.

## 목표와 역할

```text
서브컴 WSL2 /mnt/wind3dgs (읽기 전용)
  → 메인컴 Windows LAN_IP:1445 → 메인컴 WSL2:445 → 원본 프로젝트
메인컴 VS Code Remote - SSH
  → 서브컴 Windows LAN_IP:2222 → 서브컴 WSL2:22
```

Windows 10에서는 WSL2 NAT와 Windows `portproxy`를 사용한다. mirrored networking은 사용하지 않는다.
공유기 WAN 포트포워딩은 필요 없다. Windows의 기존 SMB 445를 변경하지 않고 별도 1445를 쓴다.
Samba 공유는 서브컴이 코드를 읽는 용도다. 개발·Git 조작은 메인컴 원본에서 수행한다.
서브컴 Python·캐시는 로컬에 둔다. 후속 사용자 요청으로 결과는
[별도의 쓰기 가능한 결과 공유](sub_results_share.md)의 서브컴 전용 폴더에 저장한다.

## 1. 실제 값 확인과 인계 계약

Windows PowerShell에서 `wsl -l -v`, `wsl --version`, `Get-NetIPConfiguration`,
`Get-NetConnectionProfile`, `netsh interface portproxy show all`을 조회한다.
오래된 WSL에서 `--version`이 없으면 실패를 기록하고 나머지 조회로 버전을 확인한다.
WSL에서는 `id`, `pwd -P`, `uname -r`, `ps -p 1 -o comm=`, `ss -lnt`를 확인한다.
원본 프로젝트의 AGENTS.md·README를 읽고 root와 영향을 받는 저장소 상태를 따로 확인한다.

| 변수 | 확인할 실제 값 |
|---|---|
| MAIN_LAN_IP | 메인컴 Windows의 공유기 쪽 IPv4; WSL IP와 다름 |
| SUB_LAN_IP | 서브컴 Windows의 공유기 쪽 IPv4 |
| MAIN_DISTRO | `wsl -l -v`의 정확한 메인컴 배포판 이름 |
| MAIN_WSL_IP | 해당 배포판의 기본 경로 인터페이스 IPv4 |
| PROJECT_ROOT | 원본 workspace의 실제 절대 경로 |
| SHARE_USER | Samba 인증에 사용할 기존 Linux 계정; 원본 읽기 권한 필요 |
| SUB_LINUX_USER | 서브컴 SSH 로그인 계정 |

실제 개인 경로·암호·키는 Git 문서에 넣지 않는다. 기기별 값은 프로젝트 밖 로컬 설정에 둔다.
계정명·LAN IP·배포판명·공유명·포트와 설정 완료 여부만 서브컴 담당자에게 전달한다.
Samba 암호는 사용자가 로컬 대화형 입력으로 설정하며 채팅이나 로그로 요청하지 않는다.
공유기 DHCP 예약으로 두 Windows LAN IP를 유지한다. 공유기 설정 권한이 없으면 필요한 예약값만 안내한다.
게스트 Wi-Fi/AP isolation이면 기기 간 통신 가능 여부를 먼저 확인한다.

## 2. 메인컴 WSL2: Samba 공유

Ubuntu/Debian 기준이다. 기존 Samba 설치와 공유가 있으면 설정을 먼저 백업하고 새 절만 병합한다.

```bash
sudo apt-get update
sudo apt-get install samba smbclient
```

`/etc/samba/smb.conf`에 다음 공유를 추가한다. 꺾쇠 값은 실제 확인값으로 치환한다.
프로젝트 전체가 공유되므로 먼저 secret 파일과 프로젝트 밖으로 향하는 symlink를 확인한다.
아래 제외 목록만으로 모든 secret이 가려진다고 가정하지 말고 발견된 파일도 제외한다.
부족한 권한을 해결하려고 프로젝트 전체에 `chmod -R 777`이나 소유권 변경을 하지 않는다.

```ini
[wind3dgs]
    path = <PROJECT_ROOT>
    browseable = yes
    read only = yes
    guest ok = no
    valid users = <SHARE_USER>
    follow symlinks = no
    veto files = /.env/.env.*/.git/.venv/.ssh/.codex/.agents/
```

`follow symlinks = no` 때문에 입력이 symlink라면 열리지 않는다. 필요한 입력은 실제 경로와 권한을
검토해서 제한된 별도 공유로 제공한다. `wide links`로 프로젝트 밖 전체를 노출하지 않는다.

```bash
sudo smbpasswd -a <SHARE_USER>
sudo testparm -s
```

`testparm`이 통과한 뒤 서비스를 시작한다. PID 1이 systemd이면 `sudo systemctl enable --now smbd`와
`sudo systemctl reload smbd`, 아니면 `sudo service smbd start`와 `sudo service smbd reload`를 사용한다.
서비스 변경 전에 기존 Samba 이용자가 있는지 확인한다. systemd 활성화를 위해 실행 중 WSL을 재시작하지 않는다.
`ss -lnt`에서 445 수신을 확인하고 다음으로 실제 인증·파일 읽기를 확인한다.

```bash
smbclient //127.0.0.1/wind3dgs -U <SHARE_USER> -c 'ls'
```

방화벽이 WSL 내부에서도 활성화되어 있으면 Windows→WSL 전달 연결에 필요한 범위만 허용한다.
NAT 전달 후 Samba에 보이는 source는 서브컴 IP와 다를 수 있으므로 확인 없이 `hosts allow`를 LAN IP로 고정하지 않는다.

## 3. 메인컴 Windows: 포트 전달

**관리자 PowerShell**에서 실행한다. 아래는 최초 등록 예시다. 재실행 시 기존 동일 endpoint와 규칙을
조회하여 동일하면 유지하고, 프로젝트 소유 항목만 수정한다. 다른 portproxy를 reset하지 않는다.

```powershell
$MainLanIp = '<MAIN_LAN_IP>'
$SubLanIp = '<SUB_LAN_IP>'
$MainWslIp = '<MAIN_WSL_IP>'
netsh interface portproxy add v4tov4 listenaddress=$MainLanIp listenport=1445 connectaddress=$MainWslIp connectport=445
New-NetFirewallRule -Name 'Wind3DGS-SMB-In' -DisplayName 'Wind3DGS SMB 내부망' -Direction Inbound -Action Allow -Protocol TCP -LocalAddress $MainLanIp -LocalPort 1445 -RemoteAddress $SubLanIp -Profile Private
```

MAIN_WSL_IP는 `wsl -d <MAIN_DISTRO> -- hostname -I`와 배포판 내부 `ip -4 route`, `ip -4 addr`를
함께 확인하여 선정한다. 여러 IP 문자열을 그대로 `connectaddress`에 넣지 않는다.
신뢰할 수 있는 공유기 연결의 실제 Windows 네트워크 프로필이 Private인지 확인한다.
Public 전체를 허용하거나 방화벽을 끄지 않는다. `Get-Service iphlpsvc`도 확인하며
중지되어 있으면 이 전달 기능에 필요한 IP Helper를 시작한다.

메인컴 Windows에서 WSL_IP:445, 서브컴 Windows에서 MAIN_LAN_IP:1445를 각각
`Test-NetConnection <IP> -Port <PORT>`로 확인한다. Windows 탐색기는 이 비표준 SMB 포트로
직접 연결하는 대상이 아니다. 실제 마운트는 서브컴 WSL2의 `mount.cifs port=1445`로 수행한다.

## 4. 서브컴 인계와 VS Code 접속

서브컴 담당자에게 1절의 비밀이 아닌 연결값과 [서브컴 문서](sub_pc_setup.md)를 전달한다.
서브컴 SSH 설정이 완료되면 메인컴 **Windows OpenSSH 클라이언트**에서 연결을 검증한다.
키는 메인컴 Windows 사용자 계정에 별도로 생성하고 공개키만 서브컴에 등록한다.
기존 키를 덮어쓰지 않는다. 최초 연결의 SSH host key fingerprint는 서브컴에서 확인한 값과 비교한다.

Windows 사용자 SSH config에 기존 내용을 보존하며 다음 host를 추가한다.

```sshconfig
Host wind3dgs-sub
    HostName <SUB_LAN_IP>
    Port 2222
    User <SUB_LINUX_USER>
    IdentityFile ~/.ssh/wind3dgs_sub_ed25519
    IdentitiesOnly yes
```

`ssh wind3dgs-sub`에서 `hostname`, `uname -r`로 **서브컴 WSL2**임을 확인한다.
메인컴 Windows VS Code에 Remote - SSH를 설치하고 `Remote-SSH: Connect to Host`에서
`wind3dgs-sub`를 선택한 뒤 `/mnt/wind3dgs`를 연다. 이 공유는 읽기 전용이며
서브컴 Codex의 로그·작업 파일·출력은 서브컴 로컬 작업 폴더에 둔다.

## 5. 재시작 이후 복구

자동화는 수동 연결 검증 후 작성한다. Windows 작업 스케줄러의 로컬 스크립트는 아래 계약을 따른다.

- 해당 배포판을 소유한 **Windows 사용자**의 로그인 시 실행한다. 다른 SYSTEM 계정의 WSL을 사용하지 않는다.
- 필요한 관리자 권한으로 배포판을 시작하고 smbd 시작, 기본 인터페이스 IPv4 획득, IPv4 유효성 검사를 수행한다.
- LAN 준비까지 제한된 재시도를 하고, `MAIN_LAN_IP:1445`의 프로젝트 portproxy만 갱신한다.
- 암호를 스크립트에 넣지 않는다. 기존 firewall rule은 중복 생성하지 않는다.
- systemd 서비스 활성화만으로 WSL 배포판이 항상 살아 있다고 가정하지 않는다. 무접속 상태에서도
  수신 서비스가 유지되는지 검사하고 필요하면 동일 사용자 컨텍스트의 장기 WSL 유지 작업을 구성한다.
- 로그인 전 자동 가동은 별도 검증 대상이다. WSL 수동 종료 후에는 갱신 작업을 재실행한다.

진행 중 계산이 없을 때만 사용자와 재시작 시점을 맞춰 복구 검증한다. 재시작을 못 했다면
자동 복구는 **구성 완료·실검증 미완료**로 보고한다. Windows와 WSL의 절전/종료는 공유를 끊는다.

## 6. 완료 기준·되돌리기

- 메인컴 로컬 Samba 인증, 서브컴 TCP 접속, CIFS 실제 파일 읽기 통과.
- 양쪽에서 선정한 코드·입력 파일의 SHA-256 일치, secret 제외와 쓰기 거부 확인.
- 메인컴 VS Code에서 서브컴 WSL2 터미널 접속 확인.
- 서버/클라이언트 재시작 후 재접속은 별도 결과로 기록.
- 시뮬레이션 실행 준비는 서브컴 문서의 GPU·환경·짧은 검증까지 통과해야 완료다.

실패 시 TCP → Samba 인증 → 공유 경로 권한 → 파일 읽기 순서로 조사한다.
되돌릴 때는 이 작업이 만든 공유 절, `Wind3DGS-SMB-In` 규칙, 정확한 LAN_IP:1445 portproxy와
작업 스케줄러 항목만 제거한다. 기존 설정·계정·프로젝트 데이터는 유지한다.
완료 보고에는 실제 수정, 미완료, 검증 실행 여부와 저장소별 worktree/commit/push 상태를 구분한다.

## 근거

- [Microsoft: WSL2 LAN 접근과 portproxy](https://learn.microsoft.com/en-us/windows/wsl/networking)
- [Microsoft: WSL systemd 조건](https://learn.microsoft.com/en-us/windows/wsl/systemd)
- [Samba: 공유 설정](https://www.samba.org/samba/docs/4.13/man-html/smb.conf.5.html)
- [VS Code: Remote - SSH](https://code.visualstudio.com/docs/remote/ssh)

공식 문서는 작성 시 웹으로 확인했다. 실제 기기별 적용·검증은 [현재 상태](main_pc_status.md)에서 구분한다.
