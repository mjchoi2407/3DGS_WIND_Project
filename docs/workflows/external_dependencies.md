# 외부 의존성과 patch 절차

외부 checkout의 조회·수정·patch 검증 전에 적용한다. 아래 코드 표기의 경로는 workspace root 기준이다.

## External Dependency 및 Patch 규칙

- `external/` 아래 작업 전에는 [의존성 manifest](../../manifests/external_dependencies.json)와 [patch 적용·재현 절차](../../patches/external/README.md)를 먼저 읽는다.
- Manifest에 기록된 origin, base commit, patch SHA-256, 적용 순서를 기준으로 재현한다. 임의의 `git pull`로 외부 checkout을 갱신하지 않는다.
- 기존 dirty external checkout에서 `checkout`, `reset`, `clean`, stash 또는 patch 적용을 수행하지 않는다.
- Patch 적용 검증은 별도의 clean clone 또는 clean worktree에서 수행하고, base commit과 clean 상태를 확인한 뒤 `git apply --check`를 먼저 실행한다.
- Manifest의 `modified_paths`와 허용된 generated metadata 이외의 변경이 생기면 중단하고 원인을 확인한다.
- 외부 저장소의 commit이나 remote push는 사용자가 대상 저장소와 목적을 명시적으로 승인한 경우에만 수행한다.
