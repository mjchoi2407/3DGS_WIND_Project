<!-- template: AGENTS.template.md -->
<!-- template-version: 2026-05-03 00:25:30 KST -->
<!-- localized-for: Wind_Deformable_3DGS -->

# Project Instructions

이 디렉터리는 Wind3DGS 프로젝트의 container workspace다. 루트 디렉터리 자체도
`3DGS_WIND_Project`라는 독립 Git 저장소이며, 하위 세 저장소와 합쳐 모두 네 개의 독립
저장소로 구성된다.

- `.` -> `git@github.com:mjchoi2407/3DGS_WIND_Project.git`: workspace 정책, cross-repository manifest, external patch, manuscript source
- `code/` -> `git@github.com:mjchoi2407/3DGS_WIND_Code.git`
- `ideas/` -> `git@github.com:mjchoi2407/3DGS_WIND_Ideas.git`
- `experiments/` -> `git@github.com:mjchoi2407/3DGS_WIND_Experiments.git`

하위 세 저장소는 root 저장소의 submodule이나 gitlink가 아니다. Root에서 수행한
`git status`, commit, push는 하위 저장소의 변경을 포함하지 않는다.

Project-specific topic: CG + AI research on wind-driven deformable 3D Gaussian Splatting.

Project tag for conversation/session tracking: `Wind3DGS`.

## 기록 언어 규칙

- 2026-06-27부터 새로 작성하거나 갱신하는 프로젝트 기록은 한국어를 기본 언어로 쓴다.
- 적용 대상은 `README.md`, `sessions/` 기록, 실험 보고서, 작업 로그, 스크립트가 직접 남기는 설명성 로그와 상태 메시지를 포함한다.
- 명령어, 파일 경로, 코드 식별자, API 이름, 논문/데이터셋의 공식 영문 명칭은 원문을 유지한다.
- 외부 도구가 출력한 에러 메시지, 학습 로그, 라이브러리 로그처럼 원문 보존이 필요한 출력은 번역하지 않아도 된다. 다만 사람이 덧붙이는 요약과 해석은 한국어로 쓴다.
- 사용자가 명시적으로 영어 기록이나 논문 제출용 영문 문구를 요청한 경우에만 영어를 사용한다.
- 기존 영문 기록은 별도 요청이 없는 한 소급 번역하지 않는다.

## 시작과 필요한 맥락 읽기

1. 새 대화에서는 공통 `AGENTS.md`, root `README.md`, active folder의 `AGENTS.md`와 짧은 `README.md`를 확인한다. 이미 대화에 제공되어 확인한 내용은 재출력하지 않는다. 후속 작업에서는 범위가 바뀌거나 파일 변경이 확인된 경우에만 해당 부분을 다시 읽는다.
2. Active folder는 정책·저장소 조정·manuscript는 root, 구현은 `code/`, 연구 명세는 `ideas/`, 실험·산출물은 `experiments/`다.
3. 진행을 이어받을 때 active folder의 `sessions/README.md` 최신 요약과 연결된 note 앞부분의 `현재 상태`를 먼저 읽는다. 관련 기록이 없거나 요약이 부족하면 작업 키워드로 검색해 필요한 절만 추가 확인한다.
4. 날짜 기준 session 전량 읽기, 네 저장소 이력 일괄 읽기, 긴 note의 마지막 절을 최신 상태로 추정하는 방식을 사용하지 않는다. 다른 저장소의 근거는 작업의 의존성이 있을 때만 확인한다.
5. 연구 방향이 필요한 경우 `ideas/README.md`에서 현행 문서를 찾고 관련 절만 읽는다. Archive와 과거 session은 현행 authority가 아니다.
6. `rg`로 제목·식별자·경로를 먼저 찾고 해당 구간을 읽는다. 긴 로그는 요약·실패 부분부터 확인하고 필요할 때 범위를 넓힌다. 전체 감사처럼 전량 확인이 필요한 작업은 예외다.
7. GPU teacher의 정밀도·Newmark/Gauss 선택·재시도·성능 작업 전에는 [`code/docs/gpu_runtime_selection.md`](code/docs/gpu_runtime_selection.md)를 필수로 확인한다. 상세 구현 조건은 이 문서가 연결하는 GPU 설계 문서와 실험 근거를 따른다.

## 기록의 소유권과 갱신

- 현재 방법의 수식·가정·claim은 ideas의 sketch, 단계별 완료 기준은 master, 구현 계약·파트 판정은 해당 R 문서가 소유한다.
- 실행 설정·명령·원본/hash·상세 수치와 실패 분모는 experiments의 해당 report/manifest가 소유한다. 코드 API 사용법은 code의 상세 문서가 소유한다.
- README는 진입점과 링크, session은 현재 상태·결정 이유·재발 방지 요약을 소유한다. 같은 수치·설명을 여러 곳에 복사하지 않고 소유 문서의 정확한 절을 연결한다.
- 실행 중 프레임 수·대기 상황은 TeX에 넣지 않는다. 수식·계약·확정 결과·완료 판정이 바뀔 때 관련 문서만 갱신한다. Sketch는 방법/claim 변화, master는 단계/Gate 변화가 있을 때 갱신한다.
- 이미 보존한 연구 근거를 일괄 재작성하지 않는다. 관련 작업에서 현행 요약과 링크부터 정리하고 재현 정보는 유지한다.

## 정리 요청과 R 문서 동기화

- 사용자가 작업 정리·문서 업데이트·인계를 요청하면 code/experiments 기록뿐 아니라 `ideas/README.md`가 가리키는 관련 `ideas/development/rN_*.tex`의 구현 상태·검증 근거·체크리스트도 반드시 확인한다. 모든 R 문서를 일괄 읽지 말고 변경의 영향을 받는 파트를 찾는다.
- 실제 미구현, 구현됐지만 미검증, 제한된 개발 검증 완료, canonical 완료를 구분한다. 미반영된 완료 근거와 오래된 현행 설명은 해당 R 본문·진행 요약에 반영하되, 완료 기준 전체를 충족하지 않은 체크는 올리지 않는다.
- 과거 실패·성능 근거는 당시 조건으로 보존하고 최신 상태와 분리한다. 상세 수치·원본/hash는 experiments 문서를 연결한다. Master는 단계/Gate 변경 때, sketch는 방법/claim 변경 때만 갱신한다.
- TeX를 수정하면 해당 canonical PDF를 실제 빌드하고 이를 포함하는 지정 delivery bundle을 갱신한다. 최신 진행 상태만으로 연구 계약이나 Gate를 임의 변경하지 않는다.
- 최종 보고에는 확인/갱신한 R 문서, 남은 미완료 항목과 PDF 빌드 여부를 명시한다. 관련 변경이 없으면 R 문서를 확인했으며 수정이 불필요한 이유를 짧게 적는다.

## 작업 유형과 기록 기준

- 확인·설명·리뷰 요청은 기본적으로 읽기 전용으로 수행한다. 진단 요청만으로 수정까지 확대하지 않는다.
- 변경·구현 요청은 요청 범위 안의 파일을 수정하고 위험도에 맞게 검증한다.
- 연구 방향을 바꾸는 결정, 구현 계약 변경, 실험 결과 확정은 코드 변경이 없어도 session 기록 대상이다.
- 외부 상태를 조회할 때는 fetch나 다운로드를 실제로 수행했는지와, 로컬 snapshot만 사용했는지를 결과에 명시한다.

## 독립 작업의 병렬 처리

- 일반 작업과 실행 스크립트는 의존성을 먼저 확인하고, 서로의 결과를 기다릴 필요가 없는 작업은 기본적으로 병렬 처리한다. 독립적인 조회·전처리·테스트·실험 실행·저장 결과 검산 등이 대상이다.
- 이전 상태가 필요한 시뮬레이션의 연속 frame/substep, 선행 산출물이 필요한 후속 작업, 같은 파일이나 공유 상태를 동시에 수정하는 작업은 순서를 지킨다. 병렬 작업의 출력·로그는 분리하고 완료·실패를 각각 확인한 뒤 후속 단계로 넘어간다.
- 속도 비교·벤치마크처럼 작업 간 자원 경쟁이 측정값을 왜곡하는 경우에는 측정 구간을 순차 실행하거나 자원을 분리한다. 병렬 처리량 자체를 측정하는 실험은 그 목적과 동시 실행 조건을 명시한다.
- CPU/GPU·메모리·디스크 여유와 작업별 자원 사용을 고려해 동시 실행 수를 제한한다. 같은 GPU를 공유할 때는 병렬 실행이 더 빠르다고 가정하지 않으며, 경쟁으로 전체 처리 시간이 늘어나면 동시 실행 수를 줄이거나 순차 처리한다.
- 이미 승인된 범위의 독립 작업은 반복 확인 없이 병렬화한다. 실험 목적·검증 기준·재현 조건이나 비용·범위가 달라지는 결정은 사용자에게 확인한다. 병렬화를 위해 진행 중인 실행을 임의로 중단하거나 재시작하지 않는다.

## 사용자 설명 방식: 개념 우선

- 구현 상태, 계획, 실험 결과와 문제 해결 과정을 설명할 때는 물리·수학 비전공자도 이해할 수 있도록 개념과 구체적인 예시를 먼저 제시한다.
- 기본 설명은 `무엇을 구현했는가 → 어떤 움직임이나 효과를 만드는가 → 어떻게 정확성을 확인했는가 → 무엇이 남았는가` 순서로 구성한다. 예를 들어 탄성·관성·공기저항의 역할을 설명한 뒤, 저해상도에서 고해상도로 세분해 결과가 유지되는지 확인한다고 설명한다.
- 전문 용어는 처음 사용할 때 쉬운 뜻을 함께 설명한다. 감쇠와 댐핑처럼 같은 개념을 가리키는 용어와, 공기저항처럼 그 현상의 원인이 되는 항목을 구분한다.
- 수식, 유도 과정과 상세 수학적 설명은 사용자가 요청할 때 제공한다. 그때는 앞서 설명한 개념과 각 수식·기호가 어떻게 연결되는지 설명한다. 판단에 필요한 수치·단위·통과 기준은 기본 설명에도 포함할 수 있다.
- 쉽게 설명하더라도 구현 완료, 검증 통과, 개발 진단과 최종 채택을 구분하고 적용 범위와 남은 한계를 명시한다.
- 이 규칙은 사용자에게 전달하는 설명과 보고에 적용한다. 논문 작성과 재현에 필요한 canonical 문서의 수식, 구현 계약과 상세 실험 근거는 계속 유지·갱신한다.

## 간결한 작업 기록

- 중간 보고 원문, 시간순 진행 메시지, 대기·프레임 수 보고는 파일에 기록하지 않는다. 채팅에서 필요한 진행 안내를 하는 것과 영구 기록을 구분한다.
- Session은 성공한 결과와 채택한 결정을 먼저 쓰되 검증 조건·통과 기준·미완료 범위를 함께 쓴다. 실패 중 재발 방지, 비교 분모, 논문 claim/limitation에 필요한 내용은 `조건 → 원인 → 해결 또는 재검토 조건`으로 요약한다. 단순 시행착오와 가설 나열은 남기지 않는다.
- Note 맨 앞 `현재 상태`에 확인 기준일, 완료/진행/보류, 다음 작업과 근거 링크를 둔다. 후속 결과가 생기면 이 요약을 갱신한다. 짧은 작업은 10–20줄 내외를 목표로 하되 재현 근거를 생략하기 위한 강제 상한은 아니다.
- 원본 명령/config, source revision/hash, 결과와 통과 기준은 소유 문서에 남기고 session에는 링크한다. 검증을 실행하지 않았다면 이전 기록의 판정임을 명시한다.
- 파일 변경·지속적 결정·실험 결과가 생긴 active folder만 기록한다. 읽기 전용 설명·진단은 기록하지 않는다. 같은 논리 작업은 기존 note를 갱신하고 독립된 작업만 새 note를 만든다.
- 새 note 이름은 `YYYY-MM-DD_NN_short_topic.md`; NN은 각 sessions 폴더·날짜별 두 자리 순번이다. 기존 기록은 임의로 이름을 바꾸지 않는다.
- 최종 답변은 결과·검증·남은 한계와 기록 링크를 짧게 제시한다. 실제 장애가 결과에 중요할 때만 해결 과정을 덧붙인다. 대화 원문이나 매 단계의 진행 이력을 재서술하지 않는다.

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

## 보안 및 로컬 경로

- API key, access token, password, credential, private key, cookie, 개인 절대 경로를 Git에 commit하거나 session/log에 기록하지 않는다.
- `.env`와 `.env.*`는 로컬 전용이다. 공유 가능한 변수 이름과 설명만 담은 `.env.example`만 추적할 수 있으며 실제 secret 값은 넣지 않는다.
- 설정과 manifest를 stage하기 전에 secret과 개인 경로가 포함되지 않았는지 확인한다.

## External Dependency 및 Patch 규칙

- `external/` 아래 작업 전에는 `manifests/external_dependencies.json`과 `patches/external/README.md`를 먼저 읽는다.
- Manifest에 기록된 origin, base commit, patch SHA-256, 적용 순서를 기준으로 재현한다. 임의의 `git pull`로 외부 checkout을 갱신하지 않는다.
- 기존 dirty external checkout에서 `checkout`, `reset`, `clean`, stash 또는 patch 적용을 수행하지 않는다.
- Patch 적용 검증은 별도의 clean clone 또는 clean worktree에서 수행하고, base commit과 clean 상태를 확인한 뒤 `git apply --check`를 먼저 실행한다.
- Manifest의 `modified_paths`와 허용된 generated metadata 이외의 변경이 생기면 중단하고 원인을 확인한다.
- 외부 저장소의 commit이나 remote push는 사용자가 대상 저장소와 목적을 명시적으로 승인한 경우에만 수행한다.

## LaTeX PDF 빌드 규칙

- 현재 작업에서 `.tex` 파일을 한 줄이라도 수정한 경우에는 작업을 완료하기 전에 반드시 그 변경을 반영하는 PDF 빌드를 실제로 실행한다. 주석이나 문구만 바꾼 경우도 예외로 두지 않는다.
- 수정한 `.tex`가 독립 document이면 해당 PDF를 빌드한다. Section, figure fragment 또는 input file처럼 단독 빌드할 수 없으면 이를 포함하는 최상위 canonical `.tex`를 빌드한다. 여러 canonical 문서가 직접 영향을 받으면 각 문서를 모두 빌드한다.
- 작업을 시작할 때 owning root document와 build command를 확인한다. 해당 repository의 README나 기존 build 기록에 지정된 engine과 bibliography 절차를 우선 사용한다.
- Build command의 성공 종료, PDF 생성 여부와 non-empty 결과를 확인한다. Cross-reference나 bibliography에 추가 pass가 필요하면 canonical 결과가 안정될 때까지 수행한다.
- PDF가 version-controlled canonical deliverable인 `ideas/` 문서는 source와 함께 해당 PDF를 갱신한다. Root `paper/`처럼 build PDF가 ignored인 경우에도 로컬 PDF를 생성해 검증하되 Git에 추가하지 않는다.
- Tooling 부재나 LaTeX 오류로 빌드하지 못하면 `.tex` 변경을 완료로 보고하지 않는다. 실행한 명령, 오류와 필요한 다음 조치를 사용자 및 해당 session note에 기록한다.
- 작업 시작 전부터 존재한 사용자 또는 다른 작업의 `.tex` 변경은 임의로 빌드·수정하지 않는다. 현재 작업이 그 변경을 인수하도록 사용자가 승인한 경우에만 이 규칙에 따라 처리한다.

## 연구 방향 전환 절차

현재 방법론의 canonical entry point는 `ideas/README.md`다. 연구 pivot을 수행할 때는 다음 순서를 따른다.

1. 영향을 받는 저장소별 현재 branch, commit, dirty 상태와 기존 복구점을 확인한다.
2. `ideas/README.md`가 가리키는 현행 sketch, checklist, references를 읽고 전환 범위를 확정한다.
3. 기존 아이디어를 덮어쓰거나 삭제하지 않는다. `ideas/` 정책에 따라 archive로 보존하고 새 방법은 적절한 제목의 새 문서로 작성한다.
4. 새 sketch, implementation checklist, references, `ideas/README.md`의 canonical link를 하나의 일관된 전환 단위로 갱신한다.
5. `code/`의 계약·구현과 `experiments/`의 실험·artifact가 새 방향과 호환되는지 감사한다. Legacy 결과는 새 방법의 증거로 자동 승계하지 않고 명확히 구분한다.
6. 링크, 문서 생성물, 테스트와 저장소별 diff를 검증하고 각 active folder에 전환 기록을 남긴다.
7. Commit과 push는 위 Split Repository Rules에 따라 저장소별로 처리한다.

## Folder Roles

- `code/`: reusable implementation package, configs, scripts, dependencies, and code-side sessions
- `ideas/`: canonical research index, current sketch, checklist, references, generated PDFs, archived prior ideas, and idea-side sessions
- `experiments/`: experiment READMEs, assets, outputs, reports, wrappers, and experiment-side sessions
- `paper/`: version-controlled manuscript source workspace. TeX/Bib와 선택된 figure source만 allowlist로 추적하고 build PDF 등 생성물은 로컬에 둔다.
- `assets/`: Git에서 제외되는 root-local shared visual scratch workspace. 최종 채택한 논문 figure source는 `paper/figures/`로 옮겨 검토 후 추적한다.
- `sessions/`: project-container administration and cross-repository coordination records only

The canonical current-method entry point is `ideas/README.md`.
