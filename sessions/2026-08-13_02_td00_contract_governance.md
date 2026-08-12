# TD00 계약·재현성 거버넌스 정리

## 목적

새 topology-distilled Global--Local 방법을 구현하기 전에 네 분리 저장소가 동일한 입력 상태와 artifact 정책을 기록하도록 TD00 기반을 고정한다.

## 이번 작업

- root artifact policy의 필수 run-manifest field를 실제 schema와 동기화했다.
- dataset, object package, model/checkpoint, output의 소유권과 hash 기록 위치를 명시했다.
- 실제 working run은 `experiments/artifacts/runs/`에 두고 compact evidence만 version control에 남기는 경계를 유지했다.
- code/ideas/experiments에 서로 다른 역할의 TD00 기록을 남겼다.

## 검증 경계

TD00은 repository provenance, package/schema 가용성, 실행 순서와 force-channel wiring만 검증한다. 물리 행렬, 보존성, Global--Local 직교성, transport와 rollout은 TD01 이후 검증한다.

