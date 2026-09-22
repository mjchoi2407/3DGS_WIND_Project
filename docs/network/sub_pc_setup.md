# 서브컴 Codex용: Windows 10·WSL2 공유 코드 실행

작성 기준: 2026-09-12. **설정 절차만 작성했으며 실제 네트워크·GPU 검증은 미실행이다.**
메인컴 원본을 복사 없이 읽고 서브컴 CPU/GPU로 독립 시뮬레이션을 실행하기 위한 문서다.
[메인컴 문서](main_pc_setup.md)와 한 쌍이다. 최초에는 이 두 문서를 서브컴 Codex에 전달한다.

**2026-09-12 후속 변경:** 실제 시뮬레이션 결과는 [메인컴 결과 공유](sub_results_share.md)에 직접 저장한다.
아래 로컬 runs 예시는 이전 기본안이며 새 본 실행 output은 `/mnt/wind3dgs-sub-results/<run ID>`를 쓴다.
Python·캐시·설정 로그는 계속 로컬에 둔다. 결과 마운트 확인 후 실행한다.

## Codex에게 줄 작업 지시

> 이 문서를 따라 서브컴 WSL2를 Wind3DGS 계산용으로 설정해줘.
> 메인컴 공유 폴더를 연결하고 로컬 Python·캐시·출력을 준비한 뒤 SSH와 짧은 GPU 검증을 수행해줘.
> 공유 원본을 수정하지 말고 기존 실행을 시작·중단·재개하지 마. 장기 계산은 별도 지시를 기다려줘.
> 실제 설치 버전을 확인하고 메인컴과 맞춰줘. 관리자 권한이 없는 단계는 실행할 명령으로 제공해줘.

이 문서 실행을 요청받은 뒤 설정한다. 메인컴 서버 설정과 서브컴 패키지·SSH 준비는 독립적으로
진행할 수 있지만 공유 마운트는 메인컴 TCP 1445와 Samba 인증 준비가 선행되어야 한다.

## 1. 준비 정보와 WSL2 확인

메인컴 담당자로부터 MAIN_LAN_IP, SUB_LAN_IP, 공유명 `wind3dgs`, 외부 SMB 포트 `1445`,
SHARE_USER와 메인컴 Python/NumPy/SciPy/Warp 실제 버전을 전달받는다.
이 프로젝트 메인컴에 실제 적용한 연결값은 [메인컴 인계](main_pc_status.md)를 확인한다.
암호는 사용자가 로컬 프롬프트나 보호된 로컬 파일에 입력한다. 채팅·Git·로그에 남기지 않는다.

Windows에서 `wsl -l -v`, `wsl --version`, `Get-NetIPConfiguration`, `Get-NetConnectionProfile`로
WSL2 배포판명 SUB_DISTRO와 Windows LAN IP를 확인한다. WSL에서는 `id`, `uname -r`,
`ps -p 1 -o comm=`, `ip -4 route`, `ip -4 addr`로 계정·서비스 방식·SUB_WSL_IP를 확인한다.
WSL2 미설치라면 먼저 Windows 빌드·가상화·배포판 설치 조건을 확인해 준비하며,
필요한 재부팅을 다른 실행 중 작업과 조율한다. Windows 10에서는 mirrored networking을 설정하지 않는다.

## 2. 서브컴 WSL2: 공유 코드 연결

Ubuntu/Debian 기준:

```bash
sudo apt-get update
sudo apt-get install cifs-utils openssh-server python3-venv tmux
sudo mkdir -p /mnt/wind3dgs
```

`findmnt /mnt/wind3dgs`와 디렉터리를 먼저 확인하여 기존 마운트/파일을 가리지 않는다.
`/proc/filesystems`에서 cifs를 확인하고 없으면 `sudo modprobe cifs`로 가용성을 검사한다.
지원이 없으면 오류를 기록하고 WSL 커널 업데이트 필요성을 확인한다. 패키지 설치만으로
커널 지원이 생긴다고 가정하지 않으며 SMB1로 낮춰 해결하지 않는다.

최초 연결 예시. 꺾쇠 값은 치환하며 비밀번호는 명령행에 쓰지 않는다.

```bash
sudo mount -t cifs //<MAIN_LAN_IP>/wind3dgs /mnt/wind3dgs \
  -o 'username=<SHARE_USER>,port=1445,vers=3.0,ro,uid=<SUB_UID>,gid=<SUB_GID>,nosuid,nodev'
```

SUB_UID/SUB_GID는 `id -u`, `id -g`의 실제 숫자다. 이 mount는 대화형으로 Samba 암호를 받는다.
서버의 Unix 소유권 전달 때문에 UID 매핑이 달라지면 확인 후 `forceuid,forcegid` 필요성을 판단한다.
Windows 탐색기 매핑을 거치지 않고 WSL에서 직접 SMB 서버로 연결한다.

검증: `findmnt /mnt/wind3dgs`, `ls /mnt/wind3dgs`, README 읽기와 대표 코드/입력 SHA-256 비교.
메인컴 담당자가 정한 파일 경로를 사용한다. 공유 원본이 아닌 이름이 충돌하지 않는 probe에 대한
쓰기 시도가 read-only 오류로 거부되는지 확인한다. secret 경로와 symlink는 서버에서 제한된다.

재연결용 자격 증명은 프로젝트 밖 root 소유 파일(예: `/etc/wind3dgs/smb.credentials`, 모드600)에
사용자가 안전하게 입력한다. 파일에는 `username=...`, `password=...`를 두고 출력하거나 Git에 넣지 않는다.
`/etc/fstab`을 백업한 뒤 실제 값으로 다음 항목을 병합할 수 있다.

```fstab
//<MAIN_LAN_IP>/wind3dgs /mnt/wind3dgs cifs credentials=/etc/wind3dgs/smb.credentials,port=1445,vers=3.0,ro,uid=<SUB_UID>,gid=<SUB_GID>,nosuid,nodev,_netdev,nofail 0 0
```

자동 마운트는 WSL `/etc/wsl.conf`의 `mountFsTab` 설정과 서버 준비 시점에 영향을 받는다.
실행 중 공유를 해제하지 말고 최초 검증 뒤에는 필요할 때 `sudo mount /mnt/wind3dgs`로 재연결한다.
`nofail`은 마운트 실패를 성공으로 만들지 않는다. 실행기에서 반드시 `findmnt`와 입력 hash를 확인한다.

## 3. 서브컴 WSL2 SSH와 Windows 전달

`sudo sshd -t`로 설정을 검사한다. 필요 시 기존 키를 보존하며 `sudo ssh-keygen -A`로 누락 host key만 만든다.
systemd이면 `sudo systemctl enable --now ssh`, 아니면 `sudo service ssh start`를 사용한다.
`ss -lnt`에서 22 수신을 확인한다. 메인컴 Windows 사용자 SSH 공개키를 서브컴 Linux 계정의
`~/.ssh/authorized_keys`에 중복 없이 추가하고 디렉터리700·파일600·소유자를 확인한다.
개인키는 메인컴에서 옮기지 않는다. 공개키 로그인 확인 전 기존 인증 수단을 끊지 않는다.

서브컴 **관리자 PowerShell**, 최초 등록 예시:

```powershell
$SubLanIp = '<SUB_LAN_IP>'
$MainLanIp = '<MAIN_LAN_IP>'
$SubWslIp = '<SUB_WSL_IP>'
netsh interface portproxy add v4tov4 listenaddress=$SubLanIp listenport=2222 connectaddress=$SubWslIp connectport=22
New-NetFirewallRule -Name 'Wind3DGS-SSH-In' -DisplayName 'Wind3DGS SSH 내부망' -Direction Inbound -Action Allow -Protocol TCP -LocalAddress $SubLanIp -LocalPort 2222 -RemoteAddress $MainLanIp -Profile Private
```

기존 항목과 포트 충돌을 먼저 확인하고 동일 설정을 중복 생성하지 않는다. 신뢰할 수 있는 LAN의
Private 프로필, IP Helper 서비스, WSL 내부 방화벽도 점검한다. 전체 방화벽 해제는 하지 않는다.
서브컴 Windows에서 SUB_WSL_IP:22, 메인컴 Windows에서 SUB_LAN_IP:2222 TCP 접속을 확인한다.
서브컴에서 `ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub`로 fingerprint를 확인하여
메인컴 최초 접속 때 비교한다. 메인컴 VS Code 설정은 [메인컴 문서 4절](main_pc_setup.md#4-서브컴-인계와-vs-code-접속)을 따른다.

## 4. 서브컴 로컬 실행 환경

공유 연결 후 프로젝트 AGENTS.md, code/AGENTS.md, code/README.md, code/pyproject.toml과
대상 실험 README를 읽는다. 읽기 전용 공유의 `.git`은 노출하지 않으므로 commit/dirty 상태는
메인컴에서 확인한 기록과 실제 source hash를 사용한다. 서브컴 공유에서 Git 쓰기 작업을 하지 않는다.

로컬 예시 경로:

```text
~/wind3dgs-worker/venv/       Python 환경
~/wind3dgs-worker/cache/      Warp·Python 캐시
~/wind3dgs-worker/runs/       작업별 독립 출력
~/wind3dgs-worker/logs/       로컬 실행·설정 로그
/mnt/wind3dgs/               공유 코드·입력 (읽기 전용)
```

현재 Python 지원은 3.10–3.12이며 GPU teacher 의존성은 `teacher-gpu` 그룹이다.
단순히 지원 범위의 최신 버전을 설치하지 말고 **실행에 사용할 동결 plan의 버전과 메인컴 실제 버전**을
우선 맞춘다. root requirements.txt와 과거 environments.json을 현행 lockfile로 사용하지 않는다.
현재 세 씬 실행기는 Python 실제 버전·NumPy·SciPy·warp-lang 등을 비교한다.

확인한 interpreter로 로컬 venv를 만들고 pyproject와 동결 plan에 맞는 수치 패키지를 정확한 버전으로
설치한다. 공유 소스에 `pip install -e`하여 egg-info 등을 쓰지 않는다. 현재 Python 소스는
`PYTHONPATH=/mnt/wind3dgs/code`로 직접 읽을 수 있다. 로컬 전용 환경 변수 예시:

```bash
export WIND3DGS_PYTHON="$HOME/wind3dgs-worker/venv/bin/python"
export PYTHONPATH=/mnt/wind3dgs/code
export WARP_CACHE_PATH="$HOME/wind3dgs-worker/cache/warp"
export PYTHONDONTWRITEBYTECODE=1
export OPENBLAS_NUM_THREADS=1
export OMP_NUM_THREADS=1
```

디렉터리는 미리 생성한다. 설정 파일은 로컬에만 보존하고 공유 원본에는 개인 경로를 쓰지 않는다.
서브컴 Codex가 공유에서 쓰기 제한을 만나면 로컬 작업 디렉터리에서 실행하며 공유를 입력으로 참조한다.

## 5. GPU와 짧은 실행 검증

Windows와 WSL에서 `nvidia-smi`로 GPU·드라이버를 확인한다. 현재 세 씬 경로는 `cuda:0`을 사용한다.
WSL용 CUDA는 Windows NVIDIA 드라이버를 사용한다. WSL 안에 Linux NVIDIA 디스플레이 드라이버를
설치하지 않는다. Warp wheel의 CUDA/driver 요구 사항은 설치할 정확한 버전의 공식 안내를 확인한다.

```bash
"$WIND3DGS_PYTHON" -c 'import numpy, scipy, warp; print(numpy.__version__, scipy.__version__, warp.__version__); warp.init(); a=warp.zeros(4, dtype=warp.float32, device="cuda:0"); print(a.numpy())'
```

이는 초기화·작은 메모리 왕복 검사일 뿐 시뮬레이션 통과가 아니다. CPU fallback으로 GPU 성공을 대신하지 않는다.
다음으로 해당 실험이 제공하는 짧은 smoke를 **새 로컬 출력 폴더**에서 수행한다.
시간 간격 탐색 실행기는 아래처럼 로컬 Python으로 직접 호출할 수 있다.

```bash
cd /mnt/wind3dgs
"$WIND3DGS_PYTHON" -m wind3dgs.evaluation.teacher_timestep_search \
  --smoke --device cuda:0 \
  --output "$HOME/wind3dgs-worker/runs/setup_smoke_001"
```

실행 전 현재 소스의 `--help`와 대상 README에서 플래그·작업량을 다시 확인한다. 기존 출력이면 새 이름을 쓴다.
이 smoke는 작은 문제의 저장·검산 확인이며 장기 학습데이터 발행이 아니다. 종료 코드2는 정확도
추천 없음 등일 수 있으므로 report를 확인한다. 초기화·쓰기·검산 오류와 구분하여 판정한다.
같은 작은 조건의 메인컴 결과와 비교하고 저장·재개도 별도 새 출력에서 확인한다.
GPU가 다르면 비트 단위 동일성을 가정하지 않는다. 물리 오차 기준으로 비교한다.

## 6. 현재 실행기의 경계와 장기 작업 인계

2026-09-12 확인한 `code/scripts/run_teacher_timestep_search.sh`는 공유 root `.venv`를 직접 사용한다.
`experiments/R1_teacher_velocity_reset/timestep_search/run_three_scenes.sh`도 `.venv`와 고정 v4 출력,
그 출력의 `runtime/code`를 사용한다. **두 wrapper를 서브컴에서 그대로 실행하지 않는다.**

설정 담당 Codex는 로컬 Python·공유 입력·새 로컬 출력으로 실행 가능한 경로를 검토한다.
세 씬 실행은 씬별 subprocess를 순차 실행하며 자동 분산 기능이 아니다. `--worker`는 개발 검증용이므로
이 옵션만으로 장기 작업 분배가 완성됐다고 보고하지 않는다. 특히 메인컴 진행 중 출력과 동결 plan을
수정하거나 같은 씬을 중복 실행하지 않는다. 필요한 공통 실행기 변경은 메인컴 담당자에게 경로·변경안을 인계한다.

장기 실행 전에는 씬/바람 조건별 담당표, 코드·입력 hash, 라이브러리와 실제 GPU, 고유 run ID,
정확도 기준과 저장/재개 조건을 고정한다. 한 궤적의 전후 시간을 독립 작업으로 나누지 않는다.
실행 시작 시 사용하는 동결 source 묶음은 재현성용 자동 snapshot이며 수동 코드 동기화와 별개다.
공유 개발 코드를 실행 도중 갱신된 상태로 재수입하지 않도록 현재 동결 실행 방식을 사용한다.
`tmux`는 SSH 연결 단절을 견디지만 Windows 재부팅·절전·WSL 종료를 견디는 checkpoint 대체물이 아니다.

## 7. 자동 복구와 완료 판정

메인컴 문서의 자동화 계약을 따라 서브컴 배포판 소유 Windows 사용자의 로그인 시 SSH 시작과
SUB_LAN_IP:2222 portproxy 갱신을 구성한다. 실제 SUB_WSL_IP를 매번 검증한다.
메인컴 공유 서버 준비 뒤 mount를 재시도하고, 실패 상태에서 빈 mountpoint를 입력으로 사용하지 않는다.
자동화/재부팅 검증은 실행 중 계산이 없는 시점에 수행한다. 강제 unmount나 WSL shutdown으로 검증하지 않는다.

완료 보고를 다음 세 단계로 구분한다.

1. **연결 완료:** SMB 실제 읽기·hash·쓰기 거부, SSH와 VS Code의 서브컴 WSL2 접속 통과.
2. **실행 환경 완료:** 버전 일치, GPU 실제 사용, 작은 계산·저장 검증 결과와 한계 확인.
3. **분산 본 실행 준비:** 독립 작업 분배와 실행기·동결·출력·재개 계약 검토 완료. 장기 실행 자체는 별도 지시.

재시작 후 복구는 별도 통과/미검증으로 기록한다. 설정만으로 R1 채택이나 학습데이터 발행 완료로 표시하지 않는다.
되돌리기는 새 fstab 항목·프로젝트 전용 portproxy/firewall/task만 제거하고 기존 SSH 설정은 백업 기준으로 복원한다.
마운트 해제는 사용 중 프로세스가 없을 때만 한다. 로컬 결과와 환경은 임의 삭제하지 않는다.

## 근거

- [Microsoft: WSL2 LAN 접근](https://learn.microsoft.com/en-us/windows/wsl/networking)
- [Samba: mount.cifs의 port·credentials·uid 옵션](https://www.samba.org/samba/docs/3.5/man-html/mount.cifs.8.html)
- [Microsoft: WSL systemd](https://learn.microsoft.com/en-us/windows/wsl/systemd)
- [NVIDIA: CUDA on WSL](https://docs.nvidia.com/cuda/wsl-user-guide/index.html)
- [NVIDIA Warp 설치 안내](https://github.com/NVIDIA/warp/blob/main/docs/user_guide/installation.rst)

실제 설치 시 최신 공식 문서와 설치할 버전의 호환성을 다시 확인한다.
