# 2026-09-10 01 기록과 맥락 최적화

## 현재 상태

- 확인 기준: 2026-09-22, 네 저장소의 지침·README·주제별 색인.
- 변경: 필수 지침을 구현·실행 원칙, 맥락 복구, 기록 규칙과 조건부 절차 위치로 축소했다. 맥락이 충분하면 재독하지 않으며, 부족하면 해당 주제의 최신 상태와 상세 절 링크를 따른다.
- 필수 기록: 의미 있는 개선·결정·검증·중단 시 작업 note를 갱신하고 사용자 제약·검증 범위·미확인 사항·다음 작업을 남긴다. 다음 작업은 새 실행의 포괄적 승인이 아니다.
- 지침 위치: [필수 원칙](../AGENTS.md#필수-구현실행-원칙), [조회 순서](../AGENTS.md#시작과-필요한-맥락-읽기), [기록 형식·갱신](../AGENTS.md#간결한-작업-기록), [조건부 절차](../AGENTS.md#조건부-필수-절차).
- 하위 적용: [code](../code/sessions/2026-09-10_01_token_context_optimization.md#현재-상태), [experiments](../experiments/sessions/2026-09-10_01_token_context_optimization.md#현재-상태), [ideas](../ideas/sessions/2026-09-10_01_token_context_optimization.md#현재-상태).
- 보존·한계: 직전 색인은 각 저장소의 snapshot에 원문 보존하고 과거 상태로 구분한다. 기존 note의 전면 재작성은 하지 않으며 관련 작업에서 상세 링크를 보완한다. 실제 컨텍스트·속도 절감량은 미측정이다.
- R 확인: [R1 구현·개발 검증·종료 경계](../ideas/development/r1_teacher_probe_oracle.tex)의 `sec:r1-implementation`, `sec:r1-gpu-self-contact`, 도입부 체크리스트를 확인했다. 운영 지침만 바뀌어 R 수정·PDF 빌드는 필요 없으며 기존 사용자 TeX/PDF/bundle 변경은 보존한다.
- 검증: [2026-09-22 검증](#2026-09-22-검증). 재현 가능한 최종 문서 검사와 축소량을 아래에 기록한다.

## 2026-09-22 검증

- 1차 상세 링크 규칙 반영 시 root 4개 파일의 변경 링크 8개·whitespace 검증이 통과했다.
- 후속 구조화: Markdown 28개 파일의 로컬 링크 453개, 기존 절 anchor 34개, 이동한 규칙 9개 절의 보존을 확인했다. 하위 색인 snapshot 3개는 구조화 직전 원문과 일치하고 네 저장소 `git diff --check`가 통과했다.
- Root 8개·code 7개·experiments 6개·ideas 7개 문서만 변경했다. 기존 코드·실험·TeX/PDF/bundle 변경은 보존했고, 푸시 전 네 저장소 원격 동기(HEAD...origin/main `0/0`)를 확인했다. 문서 구조화 자체로 시뮬레이션·PDF 빌드는 수행하지 않았다.
- 필수 지침 네 파일: 16,585자·29,435 bytes → 9,585자·17,734 bytes (bytes 기준 39.75% 감소).
- 하위 상태 색인 세 파일: 30,098자·50,145 bytes → 4,406자·7,557 bytes (bytes 기준 84.93% 감소). 상세 절차·원문은 조건부 문서와 snapshot에 보존했다. 이는 첫 참조 파일 크기이며 전체 문서량·실제 토큰 절감률이 아니다.
- 문서 구조·연결의 검증이며 새 채팅의 자동 행동이나 실제 컨텍스트 소비를 벤치마크한 결과는 아니다.

## 검증과 한계

아래는 2026-09-10 당시 결과다. 중간 보고 원문 삭제와 공통 시작·기록·소유권 지침 정리, 중간 보고 보존 정책 폐기와 과거 운영 note 정리를 완료했다. 각 저장소 README/지침은 고유 내용과 링크 위주로 조정했다.

- 변경 문서의 로컬 링크·Markdown anchor·whitespace를 검증했고, 네 저장소 `git diff --check`가 통과했다. 지정한 중간 보고 블록·시각 메타데이터가 남지 않았음을 확인했다.
- 성공 근거, 재발 방지용 실패 조건·원인, 원본 결과와 사용자 선택 대기는 보존했다. 실험 재실행이나 새로운 연구 채택은 없다.
- 기존 modified/untracked 작업을 보존했다. 이번 변경은 미커밋이며 stage·commit·push·fetch는 수행하지 않았다.
- 하위 기록: [code](../code/sessions/2026-09-10_01_token_context_optimization.md), [ideas](../ideas/sessions/2026-09-10_01_token_context_optimization.md), [experiments](../experiments/sessions/2026-09-10_01_token_context_optimization.md).
- 확인된 지침 네 파일은 총 30,312자에서 13,949자로 축소했다. 코드 README는 53,935자에서 1,159자로 줄이고 상세 내용은 별도 문서로 옮겼다. 실제 토큰/과금 절감률은 미측정이다.
- 정리 중 다른 작업의 기록 갱신을 확인해 수정 직전 내용을 다시 읽었으며, GPU 성능 최종 요약과 사용자 선택 대기를 보존했다.
