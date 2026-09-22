# 메인컴 설정·서브컴 인계

확인 기준: 2026-09-12. **메인컴 공유 서버·Windows 전달·서브컴 SSH 인증 완료. 서브컴 공유 마운트와 Python 실행 환경은 미완료.**

## 서브컴에 전달할 값

**결과 저장 변경:** 서브컴 결과는 메인컴 전용 폴더에 직접 저장한다.
[결과 공유 설정·서브컴 적용](sub_results_share.md)을 먼저 확인한다. 코드 공유는 읽기 전용으로 유지한다.

| 항목 | 값 |
|---|---|
| 메인컴 Windows LAN IP | `192.168.0.3` |
| 허용한 서브컴 Windows LAN IP | `192.168.0.59` (사용자 답변 `59`를 같은 대역으로 해석) |
| SMB 공유명·포트 | `wind3dgs`, TCP `1445` |
| Samba 계정 | `choi` |
| 메인컴 WSL 배포판 | `Ubuntu`, WSL2, systemd |
| Python·NumPy·SciPy·Warp | `3.12.3` / `2.4.4` / `1.18.1` / `1.17.0` |

공유 암호는 채팅/문서에 기록하지 않는다. 사용자가 메인컴 로컬 암호 설정 창에서 입력한 값을
서브컴 마운트 프롬프트에 직접 입력한다. 현재 설치 버전은 관측값이며 모든 실행 plan과의 호환 보장이 아니다.

## 완료한 설정과 검증

- 실제 apt 다운로드로 Samba·smbclient 설치, `/etc/samba/smb.conf` 원본을 `.before-wind3dgs`로 백업.
- 인증 필수·읽기 전용 프로젝트 공유 추가, smbd 시작 및 WSL 내 서비스 활성화.
- 숨김 파일/폴더, credential 이름, PEM/KEY 파일과 개인키 이름 제외. symlink 추적 금지.
- root 전용 `/etc/wind3dgs/main-smb.credentials`에 난수 임시 암호를 저장해 검증. 암호 값은 출력하지 않았다.
- 실제 SMB 인증·README 전송·SHA-256 일치, 일반 파일 쓰기 거부, `.git/config` 차단, 익명 접속 거부 통과.
- Windows 관리자 실행으로 `192.168.0.3:1445`를 WSL Samba 445로 전달.
- `Wind3DGS-SMB-In` 방화벽 규칙의 실제 표시 이름으로 netsh 조회: 로컬 IP·TCP1445·상대 `192.168.0.59`만 허용 확인.
- 실제 유선 프로필이 Public이어서 프로필 자체는 변경하지 않고 규칙을 모든 프로필에 적용했다.
  허용 IP와 포트는 위 값으로 제한한다. 일반 문서의 Private 전용 예시와 구분한다.
- Windows→WSL TCP445 연결 통과. PowerShell 5 파서로 관리자 스크립트 구문 검사 통과.
- 메인컴 Windows VS Code의 Remote - SSH `0.128.0` 및 동반 확장 설치·목록 확인 완료.
- 후속 요청으로 Windows 사용자 `.ssh/wind3dgs_sub_ed25519`에 서브컴 전용 Ed25519 키 생성 완료.
  공개키 파일은 같은 이름의 `.pub`이며 사용자에게 공개키만 전달했다. 키 내용은 Git에 기록하지 않는다.

## 사용자가 입력할 공유 암호

메인컴에 Samba 암호 설정용 PowerShell 창을 열었다. 입력은 화면에 표시되지 않는다.
그 창을 닫았거나 다시 설정하려면 **Windows PowerShell**에서 실행한다.

```powershell
wsl -d Ubuntu -u root -- smbpasswd choi
```

Linux 로그인 암호와 별개의 SMB 암호다. 변경 후 임시 검증 자격 증명은 더 이상 유효하지 않다.
임시 파일 정리는 최종 암호로 접속 검증을 마친 뒤 root 권한으로 해당 파일만 제거한다.
마지막 확인에서 임시 암호가 아직 유효했다. 사용자 암호 입력과 최종 암호로 서브컴 접속은 대기 상태다.

## Windows 전달 재적용

실행한 [관리자 스크립트](../../scripts/network/configure_main_forward.ps1)의 복사본은
Windows `%LOCALAPPDATA%\Wind3DGS\configure_main_forward.ps1`에 있다.
WSL IP가 바뀌었으면 같은 배포판을 소유한 Windows 사용자의 **관리자 PowerShell**에서 실행한다.

```powershell
& "$env:LOCALAPPDATA\Wind3DGS\configure_main_forward.ps1" -MainLanIp 192.168.0.3 -SubLanIp 192.168.0.59 -Distro Ubuntu
```

스크립트는 현재 WSL IP를 다시 조회하며 다른 포트 전달을 초기화하지 않는다.
Windows 전역 execution policy는 변경하지 않았다. 정책으로 스크립트 실행이 막히면 검토한 파일에 한해
새 PowerShell 프로세스의 `-ExecutionPolicy Bypass -File`을 사용한다.
실행 결과는 로컬 `%LOCALAPPDATA%\Wind3DGS\main-apply.log`와 `.status`에 남겼다.
자동 로그인 작업 등록과 재부팅 검증은 **서브컴 실제 연결 검증 후** 수행한다.

## 남은 작업

후속 원격 조회: 사용자가 확인한 host key를 메인컴 Windows에 등록한 뒤 `choi` 공개키 인증 통과.
Windows SSH config에 `wind3dgs-sub`를 추가하고 해당 별칭으로도 로그인 통과했다.
후속 사용자 요청으로 VS Code `--folder-uri`를 통해 서브컴 로컬 `wind3dgs-worker` 작업 폴더의
새 원격 창을 실행했다. CLI 성공 종료·SSH 폴더 접근·서브컴 VS Code 서버 디렉터리와 code 프로세스 확인.
원격 창의 GUI 연결 완료 표시는 사용자 화면에서 확인하며 공유 폴더 마운트 완료를 의미하지 않는다.
서브컴 hostname은 `DESKTOP-1ABL4SO`, WSL 커널은 `6.18.33.2`이며 NVIDIA RTX 5070,
드라이버 `581.42`, 표시 메모리 `12227 MiB`를 확인했다. 이는 nvidia-smi 조회이며 Warp 계산 검증은 아니다.
`/mnt/wind3dgs`는 빈 로컬 디렉터리이고 CIFS 마운트와 해당 fstab 항목은 없다.
로컬 worker에는 runs/logs/cache만 있으며 예정된 venv와 시스템 Python의 NumPy/SciPy/Warp는 없다.
서브컴 설정은 읽기만 했으며 변경하지 않았다.

1. 서브컴의 [설정 문서](sub_pc_setup.md)에 따른 CIFS 실제 마운트·파일 hash 검증과 재연결 구성.
2. SSH 인증·VS Code 원격 창 실행 완료. GUI 연결 완료 표시와 공유 폴더 사용은 별도 확인.
3. DHCP 예약 확인과 양쪽 재시작 복구 자동화·검증. 현재 실행 중 작업 때문에 재시작하지 않았다.
4. 서브컴 로컬 Python·캐시·출력, 짧은 GPU 검증과 작업별 실행기 준비. 기존 본 실행은 변경하지 않았다.

실제 서브컴 IP가 위 값과 다르면 연결 전 방화벽 상대 주소를 수정해야 한다.
공유 코드와 입력은 복사 없이 읽고, 서브컴 계산 출력은 별도 결과 공유의 전용 폴더로 분리한다.
