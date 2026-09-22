# Wind3DGS 재현성 manifest

이 폴더는 root project-container 저장소가 직접 포함하지 않는 split repository, 외부 코드, 환경, 데이터와 대형 artifact의 재현 정보를 관리한다.

## 파일

- `workspace_repositories.json`: 독립된 네 저장소의 remote와 TD00 전 복구점·전환 commit을 보존하는 역사적 snapshot
- `external_dependencies.json`: 외부 저장소 base commit, nested dependency, local patch와 적용 순서
- `environments.json`: 2026-08-13에 관측한 Python/CUDA/GPU 환경과 알려진 제약을 보존하는 역사적 snapshot. 현재 dependency 기준은 `code/pyproject.toml`이며 현재 설치 상태는 별도로 검증한다.
- `datasets.json`: 로컬 데이터와 derived model의 출처·역할·검증 상태
- `artifact_policy.json`: 어떤 저장소가 어떤 artifact를 소유하고 무엇을 Git에서 제외하는지 정의

## 원칙

1. `external/`, 대형 dataset, checkpoint와 runtime output은 Git에 직접 넣지 않는다.
2. 외부 코드 수정은 base commit과 SHA-256이 있는 patch로 보존한다.
3. dataset checksum이 아직 없는 경우 `pending`을 명시하며 완료된 것으로 간주하지 않는다.
4. 새 TD run은 별도의 `run_manifest.json`으로 source commit, config, seed, device, dataset/package hash를 기록한다.
5. 이 폴더의 remote 동기화 상태는 네트워크 fetch 없이 당시 local remote-tracking ref를 기준으로 기록한 값이다.
6. `workspace_repositories.json`은 live HEAD inventory가 아니다. 현재 상태는 각 저장소에서 fetch 여부를 명시하고 별도로 확인한다.
7. Root `assets/`는 Git에서 제외하는 시각 자료 scratch 공간이다. 최종 채택한 논문 figure source만 `paper/figures/`로 승격한다.
8. `.env`, `.env.*`, secret과 개인 절대 경로는 manifest나 Git 추적 파일에 기록하지 않는다. `.env.example`에는 값이 아닌 공유 가능한 변수 계약만 둔다.
