# 2026-06-27 root project remote push 준비

## 배경

사용자가 root project-container 전용 GitHub 저장소 `mjchoi2407/3DGS_WIND_Project.git`를 새로 만들었다. 이 저장소에는 split repo인 `code/`, `ideas/`, `experiments/`의 실제 내용은 올리지 않고, root coordination 파일만 올리기로 했다.

## 포함 대상

- `.gitignore`
- `AGENTS.md`
- `README.md`
- `requirements.txt`
- root `sessions/`

## 제외 대상

- `code/`, `ideas/`, `experiments/`
- `external/`, `.venv/`, `.vscode/`, `tmp/`
- `assets/`, `paper/`
- archive, installer, generated output 성격의 파일

## 처리 원칙

기존 root git history에는 split 이전의 하위 폴더 내용이 포함되어 있으므로 새 원격에는 root-only orphan history를 만들어 push한다. 이렇게 해야 새 root 저장소의 Git history에도 `code/`, `ideas/`, `experiments/` 내용이 들어가지 않는다.
