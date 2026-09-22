# 저장소별 Git 작업 절차

Stage·commit·push 또는 원격 상태 비교 전에 이 문서를 확인한다. 기본 작업 범위와 사용자 변경 보존은 [필수 지침](../../AGENTS.md#필수-구현실행-원칙)을 따른다.

## Split Repository Rules

- Root와 `code/`, `ideas/`, `experiments/`는 서로 독립된 네 Git 저장소다. 작업 전에는 영향을 받는 각 저장소에서 `git status --short --branch`를 별도로 확인한다.
- 기존 dirty worktree의 변경은 사용자 소유로 간주한다. 관련 없는 변경을 stage, 수정, stash, reset, checkout 또는 삭제하지 않는다.
- Stage할 때는 검토한 정확한 경로만 명시한다. 저장소 전체를 포괄하는 `git add -A`나 `git add .`를 기본값으로 사용하지 않는다.
- Commit은 저장소별로 diff와 검증을 확인한 뒤 각각 수행한다. Root commit이 하위 저장소 상태를 기록한다고 가정하지 않는다.
- Push는 사용자가 명시적으로 요청한 경우에만 저장소별로 수행한다. Force-push, tag 생성·push, history rewrite는 별도의 명시적 승인을 받는다.
- 원격 최신성을 주장하려면 먼저 해당 저장소에서 network fetch를 수행해야 한다. Fetch하지 않았다면 `origin/*` 비교는 local remote-tracking ref 기준이라고 명시한다.
- 완료 보고에는 영향을 받은 저장소마다 worktree, commit, push 상태를 구분해 적는다.
- Root sessions는 공통 정책·환경·저장소 조정만, 각 하위 sessions는 그 폴더의 구현·연구·실험만 기록한다. 여러 폴더를 변경하면 각 note는 고유 변경과 공통 기록 링크만 남긴다.
- 정상 작업을 위해 이 프로젝트 밖에 sibling 저장소를 만들지 않는다.
- Cross-repository push가 승인된 경우 참조되는 dependency 저장소를 먼저 push한다.
