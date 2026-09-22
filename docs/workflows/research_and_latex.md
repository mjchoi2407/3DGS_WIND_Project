# 연구 기록 동기화와 LaTeX 절차

연구·구현·실험 결과 정리, TeX 수정 또는 연구 방향 전환에 해당하는 절만 적용한다. 순수 운영 지침 변경은 연구 계약 변경이 아니다. 기본 경로는 workspace root 기준이며, [현행 연구 진입점](../../ideas/README.md#현재-구현-체크리스트)에서 영향받는 파트만 찾는다.

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

## LaTeX PDF 빌드 규칙

- 현재 작업에서 `.tex` 파일을 한 줄이라도 수정한 경우에는 작업을 완료하기 전에 반드시 그 변경을 반영하는 PDF 빌드를 실제로 실행한다. 주석이나 문구만 바꾼 경우도 예외로 두지 않는다.
- 수정한 `.tex`가 독립 document이면 해당 PDF를 빌드한다. Section, figure fragment 또는 input file처럼 단독 빌드할 수 없으면 이를 포함하는 최상위 canonical `.tex`를 빌드한다. 여러 canonical 문서가 직접 영향을 받으면 각 문서를 모두 빌드한다.
- 작업을 시작할 때 owning root document와 build command를 확인한다. 해당 repository의 README나 기존 build 기록에 지정된 engine과 bibliography 절차를 우선 사용한다.
- Build command의 성공 종료, PDF 생성 여부와 non-empty 결과를 확인한다. Cross-reference나 bibliography에 추가 pass가 필요하면 canonical 결과가 안정될 때까지 수행한다.
- PDF가 version-controlled canonical deliverable인 `ideas/` 문서는 source와 함께 해당 PDF를 갱신한다. Root `paper/`처럼 build PDF가 ignored인 경우에도 로컬 PDF를 생성해 검증하되 Git에 추가하지 않는다.
- Tooling 부재나 LaTeX 오류로 빌드하지 못하면 `.tex` 변경을 완료로 보고하지 않는다. 실행한 명령, 오류와 필요한 다음 조치를 사용자 및 해당 session note에 기록한다.
- 작업 시작 전부터 존재한 사용자 또는 다른 작업의 `.tex` 변경은 임의로 빌드·수정하지 않는다. 현재 작업이 그 변경을 인수하도록 사용자가 승인한 경우에만 이 규칙에 따라 처리한다.

## 연구 방향 전환 절차

현재 방법론은 [canonical 연구 진입점](../../ideas/README.md#현재-아이디어-스케치)을 따른다. 연구 pivot을 수행할 때는 다음 순서를 따른다.

1. 영향을 받는 저장소별 현재 branch, commit, dirty 상태와 기존 복구점을 확인한다.
2. `ideas/README.md`가 가리키는 현행 sketch, checklist, references를 읽고 전환 범위를 확정한다.
3. 기존 아이디어를 덮어쓰거나 삭제하지 않는다. `ideas/` 정책에 따라 archive로 보존하고 새 방법은 적절한 제목의 새 문서로 작성한다.
4. 새 sketch, implementation checklist, references, `ideas/README.md`의 canonical link를 하나의 일관된 전환 단위로 갱신한다.
5. `code/`의 계약·구현과 `experiments/`의 실험·artifact가 새 방향과 호환되는지 감사한다. Legacy 결과는 새 방법의 증거로 자동 승계하지 않고 명확히 구분한다.
6. 링크, 문서 생성물, 테스트와 저장소별 diff를 검증하고 각 active folder에 전환 기록을 남긴다.
7. Commit과 push는 [독립 저장소 Git 절차](repository_operations.md#split-repository-rules)에 따라 저장소별로 처리한다.

### ideas 정본 전환과 산출물

이 절의 `backup/`, `README.md`, `.gitignore`와 build directory는 ideas 저장소 기준이다. 실제 경로는 [정본 목록](../../ideas/README.md#canonical-산출물-정책)과 [허용 목록](../../ideas/.gitignore)을 따른다.

1. 이전 canonical source와 전달 산출물을 `backup/`에 보존한다.
2. 새 sketch, bibliography, checklist, PDF와 delivery bundle을 필요한 범위에서 만들고 검증한다.
3. 새 방법의 contract를 다시 통과하기 전까지 기존 구현·실험 완료 상태를 미검증으로 되돌리고 승계하지 않는다.
4. `README.md`와 `.gitignore`의 canonical deliverable allowlist를 마지막에 함께 바꿔 현재 방향을 전환한다.
5. 날짜가 있는 idea-side session note 하나를 남기고, 맞춰야 할 `code/` 또는 `experiments/` 문서를 식별한다.

- 편집 가능한 TeX/Bib source와 `README.md`가 명시하고 `.gitignore`가 허용한 현재 PDF/delivery bundle만 추적한다.
- `backup/`의 기존 tracked 산출물은 과거 기록이지 현재 방법의 근거가 아니다. 이 파일들은 보존하되 새 preview PDF, 임의 ZIP 또는 반복 revision 사본을 계속 쌓지 않는다.
- 임시 LaTeX/build output은 ignored build directory 또는 임시 directory에 둔다. 기본적으로 배포하지 않는다.
- canonical 파일명이 바뀌면 `README.md`와 `.gitignore`를 함께 갱신하고 의도한 PDF/bundle만 새로 추적 가능한지 확인한다.
- TeX, Bib, bundle, log 또는 environment 파일에 secret을 넣지 않는다. `.env`와 `.env.*`는 제외하고 secret이 없는 `.env.example`만 추적할 수 있다.
