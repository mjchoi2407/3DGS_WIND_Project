# 2026-06-29 용량 정리 후보 검토

## 배경

사용자가 workspace 안에서 필요 없는 압축파일이나 용량 확보 후보가 있는지 검토해 달라고 요청했다. 이번 작업은 특정 구현/아이디어/실험 변경이 아니라 project-container 전체 용량 감사 성격이므로 root `sessions/`에 기록한다.

공통 Startup Protocol의 `../RESEARCH_PROJECT_GUIDE.md`와 `../templates/research_project/TEMPLATE_MANIFEST.md`는 현재 AGENTS 기준 상대 경로에서 찾을 수 없었다. 대신 root 및 하위 `AGENTS.md`와 최근 session 기록을 확인했다.

## 확인한 범위

- 전체 workspace: 약 `247G`
- `experiments/M04_mesh_extraction`: 약 `237G`
- `experiments/M04_mesh_extraction/raw`: 약 `216G`
- `experiments/M04_mesh_extraction/models`: 약 `21G`
- `.venv`: 약 `4.8G`
- `external`: 약 `5.6G`

## 주요 발견

- 대형 CO3D category zip은 이미 삭제되어 있고, `downloads/co3d/category_zips`에는 로그만 남아 있다.
- 남은 대형 압축파일은 `experiments/M04_mesh_extraction/downloads/tandt_db.zip` 하나로 약 `652M`이다.
- `external/conda-home/.cache/pip/http-v2`가 약 `3.3G`이며, 설치 캐시 성격이라 비교적 안전한 회수 후보이다.
- `external/graphdeco-gaussian-splatting/SIBR_viewers` 아래 build/install 산출물이 여러 개 남아 있다.
  - `build-conda4`: 약 `773M`
  - `install`: 약 `509M`
  - `build-conda3`: 약 `213M`
  - `build-conda2`: 약 `112M`
- GOF 모델 checkpoint가 가장 실용적인 정리 후보이다. 최종 `point_cloud/iteration_30000/point_cloud.ply`가 있는 run은 중간 `chkpnt*.pth`를 모두 보관할 필요가 낮을 수 있다.

## 모델 checkpoint 후보

| Model | Checkpoints | Checkpoint size |
| --- | ---: | ---: |
| `gof_mip360_garden_i30000_images_4_mid` | `29` | `4825.7 MiB` |
| `gof_mip360_flowers_i30000_images_8` | `5` | `4187.2 MiB` |
| `gof_mip360_stump_i30000_fullres_midplus` | `29` | `2183.2 MiB` |
| `gof_mip360_stump_i30000_images_4_mid` | `29` | `1829.0 MiB` |
| `gof_mip360_treehill_i30000_images_4_mid` | `29` | `1794.0 MiB` |
| `gof_mip360_flowers_i30000_images_4_mid` | `29` | `1606.9 MiB` |
| `gof_mip360_stump_i30000_fullres_mid` | `29` | `1495.2 MiB` |
| `gof_mip360_stump_i30000_images_8_mesh` | `29` | `1170.2 MiB` |

## 원본 데이터 크기

CO3D raw category는 총 약 `205G`이다.

- `plant`: `51G`
- `teddybear`: `50G`
- `umbrella`: `40G`
- `broccoli`: `28G`
- `toyplane`: `18G`
- `kite`: `12G`
- `frisbee`: `8.6G`

Mip-NeRF 360 raw scene은 총 약 `9.9G`이다.

- `garden`: `2.9G`
- `flowers`: `2.5G`
- `treehill`: `1.8G`
- `stump`: `1.5G`
- `bonsai`: `1.4G`

## 권장 정리 순서

1. 삭제 전 확인 없이도 비교적 안전한 후보:
   - `external/conda-home/.cache/pip/http-v2`
   - 불필요한 오래된 SIBR build directory
2. 확인 후 삭제 후보:
   - `experiments/M04_mesh_extraction/downloads/tandt_db.zip`
   - 최종 산출물이 있는 GOF run의 오래된 `chkpnt*.pth`
   - 실패/대체된 model directory인 `gof_mip360_flowers_i30000_images_8`
3. 연구 판단이 필요한 큰 후보:
   - CO3D category 원본 중 현재 실험에 덜 필요한 category

## 수행한 명령

- `du -h --max-depth=2 .`
- `find . -type f -printf '%s\t%p\n' | sort -nr | head -n 120`
- `find . -type f (...) -printf ...`로 압축파일 후보 확인
- `du -sh experiments/M04_mesh_extraction/raw/co3d/* ...`
- `find experiments/M04_mesh_extraction/models -type f -name 'chkpnt*.pth' ...`

## 변경 사항

실제 데이터나 산출물은 삭제하지 않았다. 이 session 기록만 추가했다.
