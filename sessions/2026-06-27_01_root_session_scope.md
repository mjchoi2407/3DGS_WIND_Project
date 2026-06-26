# 2026-06-27 루트 session 사용 범위 수정

## 배경

사용자가 루트 `sessions/`에도 기록을 작성해도 된다고 정정했다. 단, `code`, `ideas`, `experiments` 중 하나에 귀속되는 내용은 각 하위 저장소의 `sessions/`에 남기고, 루트에는 그 범위를 제외한 프로젝트 공통 기록만 남기도록 요청했다.

## 결정

- 루트 `sessions/`는 project container 수준의 관리성 기록에만 사용한다.
- 코드 구현, 연구 아이디어, 실험 기록은 각각 `code/sessions/`, `ideas/sessions/`, `experiments/sessions/`에 계속 남긴다.
- 루트 `sessions/`에 적합한 내용은 repository split 정책, workspace-level 설정, 공통 기록 언어 정책, 환경 마이그레이션 요약, 여러 하위 저장소에 걸친 coordination 기록이다.

## 변경 파일

- `AGENTS.md`
- `sessions/README.md`
- `sessions/2026-06-27_01_root_session_scope.md`

## 다음 단계

앞으로 작업 성격에 따라 기록 위치를 먼저 분류한다. 하위 저장소에 명확히 귀속되면 해당 하위 `sessions/`에 기록하고, 프로젝트 운영/정책/환경처럼 공통 범위일 때만 루트 `sessions/`를 사용한다.
