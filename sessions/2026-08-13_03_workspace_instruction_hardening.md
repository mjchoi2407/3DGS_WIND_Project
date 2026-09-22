# Workspace 작업 지침 보강

## 목적

기본 repository split 이후 확인된 작업 지침의 모호함을 제거하고, 네 독립 저장소를 안전하게
운영하기 위한 Git·session·secret·artifact·external patch 정책을 명시한다.

## 반영 내용

- Root가 `3DGS_WIND_Project`라는 독립된 네 번째 저장소이며 하위 세 저장소가 submodule/gitlink가 아님을 명시했다.
- 새 채팅 초기화는 active folder부터 관련 기록을 점진적으로 읽도록 변경했다.
- 읽기 전용 확인·분석·설명·진단에는 session note를 만들지 않는 예외와 동일 작업 note 재사용 원칙을 추가했다.
- Dirty worktree 보존, 정확한 경로 stage, 저장소별 commit/push, fetch 기준 표시, force-push/tag 별도 승인 규칙을 추가했다.
- `.env`, `.env.*`, secret과 개인 절대 경로의 추적을 금지하고 값 없는 `.env.example`만 허용했다.
- `paper/`는 TeX/Bib 및 선택된 figure source allowlist로 추적하고 build PDF는 로컬에 두도록 정리했다.
- Root `assets/`는 Git에서 제외하는 공유 시각 자료 scratch 공간으로 확정하고, 채택한 source만 `paper/figures/`로 승격하도록 했다.
- External patch는 기록된 base/SHA-256을 기준으로 별도 clean checkout에서 검증하며 기존 dirty checkout을 변경하지 않도록 절차를 강화했다.
- `workspace_repositories.json`이 live HEAD가 아니라 TD00 전환 시점의 역사적 복구 snapshot임을 명시했다.
- `environments.json`도 관측 시점의 역사적 snapshot임을 명시하고, 이미 완료된 `pyproject.toml` dependency group 작업을 post-capture 완료 항목으로 분리했다. 개인 홈 절대 경로 대신 `${WIND3DGS_CONDA_ROOT}` 기반 path template을 기록했다.
- 현재 작업에서 `.tex`를 수정하면 독립 문서 또는 이를 포함하는 canonical root 문서의 PDF를 항상 실제로 빌드하고, 실패 시 완료로 보고하지 않는 workspace 공통 규칙을 추가했다.
- 연구 pivot 시 기존 방향 archive, 새 canonical 문서 세트 갱신, code/experiment 호환성 감사와 legacy 결과 분리를 요구하는 절차를 추가했다.

## 검증 결과

- `python3 -m json.tool`로 수정한 세 JSON manifest의 구문을 확인했다.
- `git check-ignore`로 `.env`, `.env.local`, manuscript build PDF와 `assets/`가 제외되고,
  `.env.example`, `paper/sections/*.tex`, 선택된 `paper/figures/` source가 허용되는지 확인했다.
- `git diff --check`를 통과했다.
- Root `git status --short --branch --untracked-files=all`에서 이 작업 범위의 파일만 변경·추가된 것을 확인했다.

## Git 상태

- 이 기록 작성 시 commit과 push는 수행하지 않았다.
