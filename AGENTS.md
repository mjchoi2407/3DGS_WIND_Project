<!-- template: AGENTS.template.md -->
<!-- template-version: 2026-05-03 00:25:30 KST -->
<!-- localized-for: Wind_Deformable_3DGS -->

# Project Instructions

This directory is the container workspace for the Wind3DGS project. The actual Git repositories live inside the project subfolders:

- `code/` -> `git@github.com:mjchoi2407/3DGS_WIND_Code.git`
- `ideas/` -> `git@github.com:mjchoi2407/3DGS_WIND_Ideas.git`
- `experiments/` -> `git@github.com:mjchoi2407/3DGS_WIND_Experiments.git`

Project-specific topic: CG + AI research on wind-driven deformable 3D Gaussian Splatting.

Project tag for conversation/session tracking: `Wind3DGS`.

## 기록 언어 규칙

- 2026-06-27부터 새로 작성하거나 갱신하는 프로젝트 기록은 한국어를 기본 언어로 쓴다.
- 적용 대상은 `README.md`, `sessions/` 기록, 실험 보고서, 작업 로그, 스크립트가 직접 남기는 설명성 로그와 상태 메시지를 포함한다.
- 명령어, 파일 경로, 코드 식별자, API 이름, 논문/데이터셋의 공식 영문 명칭은 원문을 유지한다.
- 외부 도구가 출력한 에러 메시지, 학습 로그, 라이브러리 로그처럼 원문 보존이 필요한 출력은 번역하지 않아도 된다. 다만 사람이 덧붙이는 요약과 해석은 한국어로 쓴다.
- 사용자가 명시적으로 영어 기록이나 논문 제출용 영문 문구를 요청한 경우에만 영어를 사용한다.
- 기존 영문 기록은 별도 요청이 없는 한 소급 번역하지 않는다.

## Startup Protocol

At the start of every meaningful task:

1. Read this `AGENTS.md` and the root `README.md`.
2. Identify the active work folder:
   - Code implementation: `code/`
   - Research framing, checklist, references: `ideas/`
   - Experiment records, assets, outputs, reports: `experiments/`
3. Read the active folder's own `AGENTS.md`.
4. If the task depends on the current research direction, read `ideas/README.md` and the current documents indexed there.
5. Write session history under the active folder's `sessions/`.
6. Use root-level `sessions/` only for project-wide administration, workspace policy, repository coordination, environment migration notes, or other records that do not belong specifically to `code/`, `ideas/`, or `experiments/`.

## 새 채팅 초기화 규칙

대화 이력이 비어 있는 새 Codex 채팅에서 첫 의미 있는 작업을 시작할 때만 다음 초기화를 수행한다. 같은 대화 중간이나 이미 맥락을 확인한 뒤에는 반복하지 않는다.

1. 이 workspace가 무엇을 하는 repo인지 먼저 확인한다. 특히 연구 테마가 `CG + AI research on wind-driven deformable 3D Gaussian Splatting`임을 확인하고, `code/`, `ideas/`, `experiments/`의 역할을 구분한다.
2. 현재 날짜 기준 최근 3일의 session 기록을 확인한다. root `sessions/`, `code/sessions/`, `ideas/sessions/`, `experiments/sessions/`에서 해당 날짜 범위의 기록을 날짜와 번호 순서대로 훑는다.
3. 최근 3일 안에 session 기록이 없거나 작업 맥락이 부족하면, 각 session 폴더에서 가장 최근 날짜의 기록을 추가로 확인한다.
4. 확인한 연구 테마, 최근 작업 흐름, 현재 활성 work folder를 짧게 내부 정리한 뒤 일반 Startup Protocol을 이어간다.

## Split Repository Rules

- Root-level `sessions/` is allowed only for cross-repository or project-container records that exclude code-side, idea-side, and experiment-side content.
- Do not use root-level `sessions/` for implementation work, research framing, experiment records, asset preparation, model training, outputs, or reports. Put those in `code/sessions/`, `ideas/sessions/`, or `experiments/sessions/` respectively.
- Do not create sibling repositories outside this project directory for normal Wind3DGS work.
- Use `code/sessions/` for code-side history.
- Use `ideas/sessions/` for idea-side history.
- Use `experiments/sessions/` for experiment-side history.
- Use root `sessions/` for workspace-level history, repository split policy, language/logging policy, environment migration summaries, and other admin records that span the project container itself.
- If a task touches multiple work folders, update `sessions/` in each touched folder.
- Name new session notes with an explicit order number: `YYYY-MM-DD_NN_short_topic.md`.
- Choose `NN` as a two-digit sequence within each target `sessions/` folder and date, starting at `01`; for example, `2026-06-24_01_external_extractors_setup.md`, then `2026-06-24_02_gpu_verification.md`.
- Numbering is independent per work folder. Do not rename legacy unnumbered session files unless the user explicitly asks for a migration.

## Folder Roles

- `code/`: reusable implementation package, configs, scripts, dependencies, and code-side sessions
- `ideas/`: canonical research index, current sketch, checklist, references, generated PDFs, archived prior ideas, and idea-side sessions
- `experiments/`: experiment READMEs, assets, outputs, reports, wrappers, and experiment-side sessions
- `paper/`: optional future manuscript workspace
- `assets/`: optional shared visual materials
- `sessions/`: project-container administration and cross-repository coordination records only

The canonical current-method entry point is `ideas/README.md`.
