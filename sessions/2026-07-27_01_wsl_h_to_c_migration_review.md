# 2026-07-27 WSL H 드라이브 → C 드라이브 이전 검토

## 배경

H 드라이브에 심각한 배드섹터가 있어 디스크 교체를 준비 중이며, 현재 H 드라이브에 있는 WSL 환경을 C 드라이브로 이전할 수 있는지 읽기 전용으로 검토했다. 이번 작업은 project-container 전체의 환경 이전 검토이므로 root `sessions/`에 기록한다.

공통 Startup Protocol의 `../RESEARCH_PROJECT_GUIDE.md`와 `../templates/research_project/TEMPLATE_MANIFEST.md`는 현재 AGENTS 기준 상대 경로에 존재하지 않았다. 대신 root `AGENTS.md`, 각 work folder의 최근 기록, 기존 WSL 이전 기록과 저장공간 감사 기록을 확인했다.

## 결론

- WSL2 Ubuntu 배포판을 H 드라이브에서 C 드라이브로 이전하는 것은 가능하다.
- C와 H는 서로 다른 물리 디스크이므로 C로 이전하면 H의 물리 장애 위험에서 벗어나는 효과가 있다.
- 현재 C 여유 공간에는 VHDX 한 개가 들어가지만, 이전 직후 약 `98.1 GiB`만 남으므로 연구 데이터 증가를 고려하면 운영 여유가 빠듯하다.
- H에 실제 읽기 오류, 멈춤, 비정상 소음이 발생한다면 일반 이전보다 디스크 복제 또는 전문 복구를 먼저 고려해야 한다.
- 현재 설치된 WSL `2.6.3.0`에는 이후 릴리스에서 수정된 cross-volume `MoveDistribution` 소유권 문제가 있으므로, 이 버전에서 `wsl --manage Ubuntu --move ...`를 바로 실행하는 것은 권장하지 않는다.
- 현 용량 조건에서는 원본을 유지한 채 C에 VHD export를 만들고, 다른 배포판 이름으로 `--import-in-place`하여 검증하는 방식이 가장 보수적이다.

## 로컬 확인 결과

### WSL

- 배포판: `Ubuntu 24.04.4 LTS`
- 등록 이름: `Ubuntu`
- WSL 형식: WSL2
- WSL 버전: `2.6.3.0`
- 커널: `6.6.87.2-microsoft-standard-WSL2`
- Windows: `10.0.19045.6466`
- 레지스트리 `BasePath`: `H:\WSL\Ubuntu`
- VHDX: `H:\WSL\Ubuntu\ext4.vhdx`
- VHDX 실제 파일 크기: `365.60 GiB`
- Linux root 사용량: 약 `317 GiB`
- `/etc/wsl.conf`: `systemd=true`, 기본 사용자 `choi`
- 등록된 다른 WSL 배포판은 없었다.
- 일반적인 Docker Desktop process/VHD 경로는 발견되지 않았다.

### 물리 디스크와 용량

| 항목 | C | H |
| --- | ---: | ---: |
| 물리 디스크 번호 | 3 | 2 |
| 연결 형식 | NVMe | SATA |
| 전체 크기 | `931.51 GiB` | `2794.52 GiB` |
| 현재 여유 공간 | `463.69 GiB` | `469.38 GiB` |

현재 크기의 VHDX 한 개를 C로 옮기면 예상 C 여유 공간은 약 `98.09 GiB`, 전체 C 용량의 약 `10.5%`이다. Windows의 `Get-Volume`/`Get-Disk`는 두 볼륨을 `Healthy`로 표시했지만 이 상태값만으로 사용자에게 알려진 배드섹터를 부정할 수는 없다.

### 프로젝트와 환경 경로

- workspace: `/home/choi/projects/2026_paper_work/Wind_Deformable_3DGS`
- Conda env:
  - `/home/choi/conda-envs/wind3dgs/gof`
  - `/home/choi/conda-envs/wind3dgs/sibr`
  - `/home/choi/conda-envs/wind3dgs/sugar`
- Conda pack 약 `24.27 GB`도 `/home/choi/conda-packs`에 있어 현재 H 기반 VHDX 안에 있다.
- 이 경로들은 모두 Linux rootfs 안에 있으므로 Ubuntu VHD 이전에 포함되고, 내부 절대경로도 유지된다.
- 활성 shell, VS Code 설정, cron, Git metadata, `/etc/fstab`에서는 `/mnt/h`에 대한 실행 의존성을 발견하지 못했다.
- 과거 output report, README, CMake/Ninja cache, `~/.codex/config.toml`에는 이전 `/mnt/h` 경로가 일부 남아 있다. 오래된 build cache는 필요할 때 재생성하는 것이 안전하다.
- `/mnt/h/...`에 실제로 있는 Windows 파일은 WSL 배포판 이전에 포함되지 않는다.

### Git 보존 필요 항목

root와 `code/`의 tracked 파일은 clean 상태였다. `ideas/`와 `experiments/`에는 아직 커밋되지 않은 변경과 새 파일이 다수 있다.

- `ideas/`: `changelog.md`, `idea_sketch.tex`, `idea_sketch.pdf`, 최근 session 기록
- `experiments/`: M04 README, smoke/quality script, mesh extraction·parameter sweep script, 최근 session 기록

전체 VHD 작업 전에 이 작은 핵심 변경분을 Git commit/push 또는 건강한 별도 저장소로 먼저 보존해야 한다.

## 권장 이전 방식

현재 조건에서 권장하는 방식은 다음과 같다.

1. H 쓰기와 대형 학습을 중단한다.
2. 커밋되지 않은 코드·기록과 대체 불가능한 결과부터 정상 디스크 또는 원격 저장소에 별도 보존한다.
3. 실제 I/O 오류나 장시간 멈춤이 있으면 export를 반복하지 말고 물리 디스크 복제/전문 복구로 전환한다.
4. 아직 안정적으로 읽힌다면 Windows PowerShell에서 WSL을 완전히 종료한다.
5. C의 일반 NTFS 폴더에 VHD 형식으로 export한다.
6. 기존 `Ubuntu`를 지우지 않고 `Ubuntu-C` 같은 새 이름으로 export VHD를 `--import-in-place`하여 부팅·프로젝트·Conda 환경을 검증한다.
7. 새 배포판을 기본값으로 바꾸고 충분히 사용한 뒤에만 H의 기존 배포판 정리를 별도 결정한다.

이 방식은 C에 tar와 새 active VHD를 동시에 둘 공간이 부족한 현재 조건에서 VHD 한 개만 사용하며, 검증 전 원본 등록과 VHD를 보존한다.

`wsl --manage Ubuntu --move C:\WSL\Ubuntu`는 설치된 도움말에서 지원되지만, 현재 `2.6.3.0`에서는 바로 사용하지 않는다. 이 방식을 선택하려면 먼저 최신 안정판 WSL로 업데이트하고, 별도 백업을 확보한 뒤 수행한다.

## 후속 결정: C 임시 이전 후 교체 디스크로 최종 이전

사용자는 먼저 WSL 환경을 C에 임시로 대피시키고, 교체 디스크가 준비되면 새 디스크로 최종 이전하는 방향을 제안했다. 현재 조건에서는 이 2단계 전략이 적합하다.

1. 장애 위험이 있는 H → 건강한 C:
   - 원본을 보존한 채 `wsl --export ... --format vhd`와 `--import-in-place`로 `Ubuntu-C`를 만든다.
   - C 복제본의 부팅, 프로젝트, Conda 환경과 주요 결과를 검증한다.
   - 검증 전에는 기존 H의 `Ubuntu`를 unregister하지 않는다.
2. 건강한 C → 새 교체 디스크:
   - WSL을 최신 안정판으로 업데이트한다.
   - 새 디스크를 일반 NTFS, 비압축·비암호화 폴더로 준비한다.
   - C의 `Ubuntu-C`가 정상이고 별도 중요 데이터 백업이 확보된 상태에서 최신 `wsl --manage Ubuntu-C --move <새 경로>`를 사용한다.
   - 최종 BasePath와 runtime을 검증한 뒤 C 복사본과 기존 H 등록 정리를 별도 결정한다.

C 임시 운영 중 예상 여유 공간은 약 `98.1 GiB`이므로 대형 학습, dataset 추가 다운로드, mesh sweep처럼 VHD를 크게 확장할 작업은 중단한다. 교체 디스크가 준비되는 즉시 최종 이전하고, 장기적으로는 WSL 환경과 대형 raw/output data의 저장 위치를 분리한다.

## 주의 사항

- `wsl --unregister Ubuntu`는 배포판 데이터를 영구 삭제하므로 검증 전에 실행하지 않는다.
- 실행 중인 `ext4.vhdx`를 Explorer, `Move-Item`, 레지스트리 수동 편집으로 옮기지 않는다.
- 원본 H에서 `chkdsk /r`, `e2fsck`, compact, sparse 변환, `fstrim`, 전체 hash를 먼저 실행하지 않는다. 실제 물리 오류가 있다면 추가 부하와 쓰기가 복구 가능성을 낮출 수 있다.
- C 목적지 폴더에는 NTFS 압축과 EFS 암호화를 적용하지 않는다.
- C에 이전한 뒤에는 대형 CO3D raw data와 중간 산출물을 새 건강한 데이터 디스크로 분리하거나 C 여유 공간을 추가 확보한다.

## 공식 자료

- Microsoft Learn, WSL 기본 명령과 export/import:
  - <https://learn.microsoft.com/en-us/windows/wsl/basic-commands>
- Microsoft Learn, WSL FAQ의 백업·이전과 unregister 경고:
  - <https://learn.microsoft.com/en-us/windows/wsl/faq>
- Microsoft Learn, WSL2 VHD 구조·위치·복구:
  - <https://learn.microsoft.com/en-us/windows/wsl/disk-space>
- Microsoft WSL `2.7.3`, cross-volume move 후 VHD ownership 수정:
  - <https://github.com/microsoft/WSL/releases/tag/2.7.3>
- Microsoft WSL `2.7.11`, `MoveDistribution` ownership restore 후속 수정:
  - <https://github.com/microsoft/WSL/releases/tag/2.7.11>
- Microsoft disk error 지침:
  - <https://learn.microsoft.com/en-us/troubleshoot/windows-server/backup-and-storage/troubleshoot-data-corruption-and-disk-errors>

## 변경 사항

- 실제 WSL, VHDX, Windows 설정, 프로젝트 코드와 데이터는 변경하지 않았다.
- 이 검토 session 기록만 추가했다.
