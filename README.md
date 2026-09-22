<!-- template: README.template.md -->
<!-- template-version: 2026-04-30 19:29:34 KST -->
<!-- localized-for: Wind_Deformable_3DGS -->

# Wind Deformable 3DGS

Wind3DGS의 분리된 저장소를 함께 운영하기 위한 container workspace이자 독립된 governance 저장소다.

## Project Repositories

- root (`3DGS_WIND_Project`): project-container 정책, cross-repository 조정, 재현성 manifest, external patch, manuscript source와 root session note를 관리하는 독립 저장소
- `code/`: reusable implementation and code-side session notes
- `ideas/`: canonical research index, current sketch, checklist, references, archived prior ideas, and idea-side session notes
- `experiments/`: experiment records, assets, outputs, reports, and experiment-side session notes

Root와 세 하위 폴더는 모두 독립 Git 저장소다. 하위 저장소는 submodule/gitlink가 아니며,
root의 commit이나 push에 포함되지 않는다.

## Current Research Direction

`ideas/README.md` is the stable entry point for the current method. It indexes the active idea sketch, implementation checklist, bibliography, generated PDFs, and the archive boundary for prior directions.

## Reproducibility Records

- `manifests/`: split-repository recovery points, external dependency pins, environment observations, dataset inventory, and artifact ownership policy
- `patches/external/`: exact local diffs required to reproduce modified external tools
- `paper/`: version-controlled TeX/Bib and selected figure sources; manuscript build PDF와 임시 생성물은 로컬에 둔다
- `assets/`: Git에서 제외하는 root-local visual scratch 공간; 최종 채택한 figure source만 `paper/figures/`로 옮긴다

The root repository does not vendor `external/` or the three split repositories. Reconstruct them from the recorded remotes and commits, then apply only the patches listed in `manifests/external_dependencies.json`.

`manifests/workspace_repositories.json`은 TD00 전환 시점의 복구점과 전환 commit을 보존하는
역사적 snapshot이다. 현재 branch HEAD나 원격 최신 상태를 자동으로 나타내지 않으며, 최신
원격 상태를 판단하려면 각 저장소에서 별도로 fetch해야 한다.

## 작업 시작

- Windows 10 두 대의 WSL2 공유 실행 환경: [현재 메인컴 설정·인계](docs/network/main_pc_status.md), [메인컴 절차](docs/network/main_pc_setup.md), [서브컴 절차](docs/network/sub_pc_setup.md).

- 공통 [AGENTS.md](AGENTS.md)와 active folder의 지침을 따른다. 이미 확인한 지침은 변경된 부분만 재확인한다.
- 맥락이 부족할 때만 해당 `sessions/README.md`에서 주제별 최신 note의 `현재 상태`를 찾고, 거기에 명시된 상세 문서·절 링크로 필요한 근거를 확인한다. 검색은 연결이 없거나 불충분할 때 사용한다.
- 주제별 상태 복구: [공통 운영](sessions/README.md#현재-상태), [구현](code/sessions/README.md#현재-상태), [연구](ideas/sessions/README.md#현재-상태), [실험](experiments/sessions/README.md#현재-상태). 필요한 주제만 선택한다.
- 실행·수정 전 해당 [조건부 필수 절차](AGENTS.md#조건부-필수-절차)를 확인한다. 실제 파일·프로세스·버전 확인과 안전 규칙은 맥락 재사용 여부와 관계없이 적용한다.

## Git Remotes

- root: `git@github.com:mjchoi2407/3DGS_WIND_Project.git`
- `code/`: `git@github.com:mjchoi2407/3DGS_WIND_Code.git`
- `ideas/`: `git@github.com:mjchoi2407/3DGS_WIND_Ideas.git`
- `experiments/`: `git@github.com:mjchoi2407/3DGS_WIND_Experiments.git`

The root repository intentionally excludes the split repository contents under `code/`, `ideas/`, and `experiments/`. Clone or update those repositories separately.

## 기록

기록 위치·언어·Git·보안·재현성 규칙은 [공통 지침](AGENTS.md)을 따른다.
중간 보고 원문은 저장하지 않으며, 결과·결정·재발 방지 요약과 근거 링크를 각 소유 폴더에 남긴다.
