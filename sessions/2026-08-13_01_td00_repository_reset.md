# 2026-08-13 TD00 저장소 전환과 재현성 고정

## 목적

기존 mesh-proxy/procedural-wind 방향의 자산을 잃지 않으면서, 현재 `Topology-Distilled, Error-Triggered Global--Local Wind Dynamics` 방법을 구현하기 전 저장소 경계와 복구점을 고정했다.

## 보존 작업

네 저장소에서 기존 미커밋 작업을 먼저 독립 커밋으로 보존했다.

- root: `08c81ce` — 프로젝트 관리 기록
- code: `42df21f` — 환경과 GPU 호환성 기록
- ideas: `5bc3ead` — 이전 아이디어 백업과 새 방법 문서
- experiments: `2197ce0` — M04 mesh extraction 작업

각 커밋에 로컬 tag `pre-td00-repo-reset-2026-08-13`을 만들었다. 원격 push는 수행하지 않았다.

## 문서와 milestone 전환

- `ideas/README.md`를 현재 방법의 안정적인 canonical index로 지정했다.
- 존재하지 않는 `RESEARCH_PROJECT_GUIDE.md`, 이전 `idea_sketch.tex`와 이전 `implementation_checklist.md` 참조를 활성 AGENTS/README에서 제거했다.
- M01--M04는 삭제하지 않고 static I/O baseline, E0 fixture 후보, legacy proxy/procedural comparison, offline preprocessing/mesh baseline으로 역할을 다시 명시했다.
- 새 실험 namespace는 TD00--TD14이며 이전 M## 완료 상태를 승계하지 않는다.

## 외부 코드 보존

다음 local diff를 `patches/external/`에 `git diff --binary` 형식으로 보존했다.

- SIBR core WSLg/CC6.x compatibility patch
- SIBR 내부 CudaRasterizer sm_61/allocation diagnostic patch
- Gaussian Opacity Fields build compatibility patch
- SuGaR simple-knn compatibility patch

각 patch의 base commit, remote, SHA-256, modified path, 제외한 build artifact와 적용 순서는 `manifests/external_dependencies.json`에 기록했다. 네 patch 모두 해당 base commit의 clean `git archive`에서 `git apply --check`를 통과했다.

## 환경·데이터·artifact 정책

- root `.venv`와 gof/sibr/sugar 환경의 현재 Python 및 핵심 package 버전을 기록했다.
- 현재 sandbox에서는 GPU/NVML 접근과 `nvcc`가 없으며, 이전 native probe의 GTX 1080 Ti CC 6.1 정보와 구분해 기록했다.
- 공식 3DGS T&T+DB archive의 크기와 SHA-256, CO3D/Mip-NeRF 360 local inventory, GOF derived model 상태를 기록했다.
- 대형 TD artifact는 `experiments/artifacts/` 아래에 두고 Git에서는 manifest와 retrieval rule만 추적하기로 했다.
- `paper/main.tex`, `paper/refs.bib`과 빈 figure/section scaffold는 root에서 추적하고 생성 PDF는 기본적으로 제외한다.

## 검증

- 네 주 저장소의 보존 커밋과 복구 tag 확인
- 활성 문서의 깨진 canonical path 검색 결과 0건
- JSON manifest parse 성공
- 외부 patch SHA-256 일치
- 외부 patch clean-base apply check 통과
- archive patch를 제외한 일반 파일의 `git diff --check` 통과
- archive patch는 원본 공백/개행을 유지한 상태로 SHA-256과 clean-base `git apply --check` 통과

## 제외한 작업

- 원격 push
- 외부 저장소 자체 commit
- dataset/checkpoint 삭제
- 본격적인 Global/Local solver 구현

다음 단계는 TD00 packaging, dependency group, typed contract, run manifest schema와 deterministic test scaffold다.
