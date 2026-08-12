# 2026-07-29 WSL 최종 이전 위치 확인

## 배경

사용자가 교체 디스크로 WSL 이전을 완료했다고 알려 최종 등록 위치와 Linux 환경 보존 여부를 확인했다. 이번 확인은 project-container 전체 환경 이전에 해당하므로 root `sessions/`에 기록한다.

## 확인 결과

- 등록 배포판: `Ubuntu`
- WSL 형식: WSL2
- Windows registry `BasePath`: `E:\WSL\Ubuntu`
- VHD 파일명: `ext4.vhdx`
- 배포판 상태: 실행 중
- Linux root filesystem:
  - 전체 약 `1007G`
  - 사용 약 `318G`
  - 여유 약 `639G`
- 기존 Conda 환경 보존:
  - `/home/choi/conda-envs/wind3dgs/gof`
  - `/home/choi/conda-envs/wind3dgs/sibr`
  - `/home/choi/conda-envs/wind3dgs/sugar`

따라서 WSL 배포판은 기존 H 드라이브가 아니라 최종 교체 디스크의 `E:\WSL\Ubuntu`에서 정상 실행 중이다.

## 후속 작업

- 누락되어 있던 Conda base 관리 기능을 `/home/choi/miniforge3`에 복구했다.
- 상세 설치·등록·CUDA 검증 결과는 `code/sessions/2026-07-29_02_miniforge_base_registration.md`에 기록했다.

## 변경 사항

- WSL 등록 위치나 VHD 설정은 변경하지 않았다.
- Miniforge 및 shell 설정 변경은 code-side 기록에 별도로 남겼다.
- 본 root session 기록을 추가했다.
