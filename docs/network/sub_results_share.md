# 서브컴 결과를 메인컴에 직접 저장

2026-09-12 사용자 요청으로 결과 저장 방식을 변경했다. **메인컴 공유 생성·권한 검증 완료,
서브컴 마운트 적용은 대기 상태**다. 기존 문서의 서브컴 로컬 runs 저장 기본안을 대체한다.

| 항목 | 위치/값 |
|---|---|
| 메인컴 실제 결과 폴더 | workspace 상대 `experiments/artifacts/runs/sub_pc/` |
| 결과 공유 | `//192.168.0.3/wind3dgs-sub-results` |
| SMB 포트·계정 | `1445`, `choi` (기존 Samba 암호) |
| 서브컴 마운트 위치 | `/mnt/wind3dgs-sub-results` |
| 실행별 출력 | `/mnt/wind3dgs-sub-results/<고유 run ID>/` |
| 코드·입력 공유 | `/mnt/wind3dgs`, 기존대로 읽기 전용 |

Samba를 통해 쓸 수 있는 프로젝트 범위는 이 결과 폴더뿐이다. 공유 루트를 벗어나는 symlink 추적은
금지했다. 파일은 인증한 choi 계정으로 생성하며 디렉터리/파일 접근 권한도 제한한다.
이 제한은 **SMB 공유 접근 범위**이며 서브컴 자체 로컬 디스크 쓰기를 막는 운영체제 sandbox는 아니다.
Python 환경과 캐시는 계속 서브컴 로컬에 둔다. 물리 원본·코드·메인컴 기존 결과는 수정하지 않는다.

## 서브컴 적용

[mount_sub_results.sh](../../scripts/network/mount_sub_results.sh)를 서브컴 로컬에서 실행한다.
서브컴 SSH 세션의 sudo는 암호가 필요하고 Windows interop 실행도 불가능하여 원격 관리자로 실행하지 않았다.
서브컴 VS Code 터미널에서 다음을 실행한다.

```bash
sudo bash ~/wind3dgs-worker/mount_sub_results.sh
```

먼저 sudo용 서브컴 Linux 암호를 요구할 수 있다. 기존 Samba 자격 증명 파일이 없으면
Samba choi 암호를 별도로 요청하며 입력은 표시되지 않는다. 두 암호를 혼동하지 않는다.
스크립트는 기존 자격 증명을 재사용하고 mount 성공 후에만 fstab 항목을 추가한다.
코드 공유 설정은 변경하지 않는다. 기존 결과 마운트/fstab/파일이 있으면 보존하며 충돌을 보고한다.

마운트 전 디렉터리는 일반 사용자에게 쓰기 불가능하게 두어 연결이 풀렸을 때 로컬에 잘못 저장될
가능성을 줄인다. 실행기에서도 다음 검사를 반드시 수행하고 실패하면 계산을 시작하지 않는다.

```bash
mountpoint -q /mnt/wind3dgs-sub-results
findmnt -rn -M /mnt/wind3dgs-sub-results -o SOURCE,FSTYPE
```

실제 실행은 이 경로 아래 새 run ID로 output을 지정한다. 고정 출력/프로젝트 `.venv`를 사용하는
기존 wrapper를 그대로 실행하지 않는다. 다른 실행과 같은 디렉터리를 사용하지 않는다.
재부팅 후 fstab 자동 마운트는 서버 준비 시점에 따라 실패할 수 있어 재연결 검증이 별도로 필요하다.
네트워크 단절 때 자동으로 로컬 저장으로 전환하지 말고 실패를 보고하고 확정 checkpoint에서 재개한다.

## 검증과 남은 범위

- 메인컴 Samba 설정 검사·서비스 reload 완료. 기존 서비스 재시작과 시뮬레이션 중단 없음.
- 사용자가 메인컴 로컬 창에 입력한 현재 암호로 결과 공유 인증 통과.
- 새 전용 probe 디렉터리에서 파일 쓰기·읽기 내용 일치·rename·probe 정리 통과.
- 동일 계정의 기존 코드 공유 쓰기 거부와 결과 공유의 상위 README 접근 거부 확인.
- 결과 폴더는 experiments Git ignore 대상임을 확인. 생성 데이터는 Git에 넣지 않는다.
- 마운트 스크립트 Bash 구문 검사 통과. 서브컴에서의 실제 mount·재시작·장기 쓰기/재개는 미검증.

검증 probe만 생성 후 정리했으며 기존 결과를 삭제하지 않았다. 비밀번호는 문서·로그·Git에 남기지 않았다.
실행기 연결과 큰 데이터 저장 성능 검증은 별도다.
