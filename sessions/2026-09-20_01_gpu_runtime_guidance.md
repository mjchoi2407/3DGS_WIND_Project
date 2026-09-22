# GPU teacher 실행 지침 연결

## 현재 상태

- 확인 기준: 2026-09-20.
- GPU teacher 정밀도·Newmark/Gauss 선택 작업 전에 `code/docs/gpu_runtime_selection.md`를 필수로 읽도록 최상위 `AGENTS.md`에 연결했다.
- 현행 선택은 GPU별 Mixed32 범위, Newmark→Gauss 전환 세 조건, FP64 authority/독립 검산 유지와 생산·학습 승격 보류를 명시한다.
- 공통 정책 연결만 root가 소유하며, 구현·실험 세부 근거는 각각 code/experiments 기록이 소유한다.
- 2026-09-22 누적 구현·연구·실험 변경을 저장소별로 정리해 `code` `6b4fadd`,
  `ideas` `e40ea9f`, `experiments` `d5e8ce9`로 `origin/main`에 push했다. Root 운영 문서는
  이 기록을 포함하는 후속 root commit에서 같이 고정한다.
