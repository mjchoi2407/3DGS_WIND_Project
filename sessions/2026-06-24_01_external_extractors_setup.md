# 2026-06-24 External Extractors Conda Setup

## Context

GOF(Gaussian Opacity Fields)와 SuGaR를 외부 mesh extraction baseline으로 사용하기 위해 project-local Conda 환경을 구성했다. Conda 배포판은 `external/miniforge3`에 설치했고, 사용자 홈 오염을 피하기 위해 `HOME=external/conda-home`을 사용했다.

공식 코드는 다음 위치에 둔다.

- GOF: `external/gaussian-opacity-fields`
- SuGaR: `external/SuGaR`
- Nvdiffrast for SuGaR: `external/SuGaR/nvdiffrast`

`external/`은 git 추적 대상이 아니라 로컬 의존성/공식 baseline checkout 영역으로 둔다.

## Conda Environments

활성화:

```bash
source external/miniforge3/etc/profile.d/conda.sh
conda activate gof
conda activate sugar
```

또는 shell activation 없이 다음처럼 실행할 수 있다.

```bash
HOME=$PWD/external/conda-home external/miniforge3/bin/conda run -n gof python -c "..."
HOME=$PWD/external/conda-home external/miniforge3/bin/conda run -n sugar python -c "..."
```

생성된 env:

- `gof`: GOF용 Python 3.8 / PyTorch 1.12.1 + CUDA 11.3 계열
- `sugar`: SuGaR용 Python 3.9 / PyTorch 2.0.1 + CUDA 11.8 계열

Conda package cache는 `/mnt/h`에서 대형 패키지 extract가 느리거나 불안정할 수 있어 `/tmp/wind3dgs-conda-pkgs`를 사용했다.

## GOF Setup

GOF env에 다음을 구성했다.

- `torch==1.12.1+cu113`
- `torchvision==0.13.1+cu113`
- CUDA compiler/toolchain for extension build
  - `cuda-nvcc=11.3.58`
  - CUDA runtime/dev headers
  - GCC/G++ 9.5
- Built extensions:
  - `external/gaussian-opacity-fields/submodules/simple-knn`
  - `external/gaussian-opacity-fields/submodules/diff-gaussian-rasterization`

Build target은 현재 사용자의 GTX 1080 Ti에 맞춰 `TORCH_CUDA_ARCH_LIST=6.1`로 지정했다.

검증:

```text
torch 1.12.1+cu113 11.3 False
torchvision 0.13.1+cu113
gof extensions ok
```

## SuGaR Setup

SuGaR env는 공식 `environment.yml`을 기반으로 구성했다.

- `torch==2.0.1` / CUDA 11.8
- `torchvision==0.15.2`
- `pytorch3d==0.7.4`
- `open3d==0.17.0`
- CUDA compiler/toolchain for extension build
  - `cuda-nvcc=11.8.89`
  - GCC/G++ 11.4
- Additional CUDA dev headers for `nvdiffrast`
  - `libcusparse-dev=11.7.5.86`
  - `libcublas-dev=11.11.3.6`
  - `libcusolver-dev=11.4.1.48`

Built extensions:

- `external/SuGaR/gaussian_splatting/submodules/simple-knn`
- `external/SuGaR/gaussian_splatting/submodules/diff-gaussian-rasterization`
- `external/SuGaR/nvdiffrast`

SuGaR의 `simple-knn`은 CUDA 11.8/GCC 11 조합에서 `FLT_MAX` include가 빠져 빌드가 실패했다. 공식 코드 checkout 내부의 `simple_knn.cu`에 `#include <float.h>`를 추가해 로컬 호환 패치로 처리했다. `external/` 내부 변경이므로 본 repository contribution으로 보지 않는다.

검증:

```text
torch 2.0.1 11.8 False
torchvision 0.15.2
open3d 0.17.0
sugar extensions ok
```

## Caveat

Codex 실행 셸에서는 GPU가 노출되지 않아 두 env 모두 `torch.cuda.is_available()`가 `False`로 출력된다. 이전 사용자 터미널에서는 CUDA device가 보였으므로, 실제 extraction 실행은 사용자 shell에서 같은 env를 activate한 뒤 다시 확인해야 한다.

GPU 확인:

```bash
source external/miniforge3/etc/profile.d/conda.sh
conda activate sugar
python - <<'PY'
import torch
print(torch.__version__, torch.version.cuda)
print(torch.cuda.is_available())
print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else "no cuda device")
PY
```

## GPU Verification Update

승인된 GPU 접근 모드에서 확인한 결과, WSL/NVIDIA driver와 세 Python 환경 모두 CUDA device를 정상 인식했다.

System GPU:

```text
NVIDIA-SMI 580.126.10
Driver Version: 582.28
CUDA Version: 13.0
GPU: NVIDIA GeForce GTX 1080 Ti
VRAM: 11264 MiB
```

PyTorch CUDA smoke test:

```text
env=gof
torch 1.12.1+cu113
torch.version.cuda 11.3
cuda_available True
device_count 1
device_name NVIDIA GeForce GTX 1080 Ti
cuda_tensor_sum 4.0

env=sugar
torch 2.0.1
torch.version.cuda 11.8
cuda_available True
device_count 1
device_name NVIDIA GeForce GTX 1080 Ti
cuda_tensor_sum 4.0

env=.venv
torch 2.11.0+cu126
torch.version.cuda 12.6
cuda_available True
device_count 1
device_name NVIDIA GeForce GTX 1080 Ti
cuda_tensor_sum 4.0
```

GOF/SuGaR compiled extension imports:

```text
gof extension imports ok
device capability: (6, 1)

sugar extension imports ok
device capability: (6, 1)
```

Available CUDA compilers:

```text
/usr/local/cuda-12.6/bin/nvcc: 12.6
external/miniforge3/envs/gof/bin/nvcc: 11.3
external/miniforge3/envs/sugar/bin/nvcc: 11.8
```

## Sample and Entrypoint Verification

공식 repo 안의 자가완결 sample/demo를 확인했다.

- GOF는 bundled sample dataset/checkpoint가 없고, README의 공식 실행 예시는 외부 COLMAP/3DGS checkpoint를 요구한다.
- SuGaR도 bundled scene/checkpoint는 없고, `train_full_pipeline.py` / `extract_mesh.py`는 외부 COLMAP scene 또는 3DGS checkpoint를 요구한다.
- SuGaR에 포함된 `nvdiffrast`에는 자체 sample data와 torch sample이 있다.

GOF entrypoint:

```text
python train.py --help: OK
python extract_mesh.py --help: OK
```

GOF `extract_mesh.py`는 `tetranerf` triangulation extension을 요구한다. 누락되어 있어 다음을 보완했다.

- Installed `cgal`, `gmp`, `mpfr`, `pybind11` into `gof`.
- Built and installed `external/gaussian-opacity-fields/submodules/tetra-triangulation`.
- Local compatibility patch in ignored `external/`:
  - `CMakeLists.txt`: build as CXX extension instead of CUDA language project, because the triangulation code only needs CUDA vector types from headers.
  - `CMakeLists.txt`: use `find_package(pybind11)` from conda instead of FetchContent.
  - `CMakeLists.txt`: use `CMAKE_CXX_STANDARD 17` for CMake 3.28/4.x compatibility.
  - `cmake/FindTorch.cmake`: suppress Torch import stdout warnings so library/include paths are not polluted by `No CUDA runtime is found...`.
- Used system `/usr/bin/cmake` 3.28.3 rather than conda CMake 4.3 for this submodule.

GOF Tetra smoke test:

```text
cuda_available True
points (5, 3) cuda:0
cells (2, 4) torch.int32 cuda:0
[[3, 1, 0, 2], [3, 4, 1, 2]]
```

GOF all extension import:

```text
GOF all extension imports ok
cuda True NVIDIA GeForce GTX 1080 Ti
```

SuGaR entrypoint:

```text
python train_full_pipeline.py --help: OK
python extract_mesh.py --help: OK
```

SuGaR/nvdiffrast official sample:

```text
python external/SuGaR/nvdiffrast/samples/torch/triangle.py: OK
output: /tmp/wind3dgs_nvdiffrast_sample/tri.png
PNG: 256 x 256 RGB
non-empty bbox: (26, 27, 229, 230)
```

The sample required `imageio`, so `imageio=2.37.0` was added to the `sugar` env.

Minimal CUDA Gaussian rasterizer smoke tests:

```text
sugar raster ok (3, 32, 32) (1,) 52.699703216552734 [10]
gof raster ok (9, 32, 32) (1,) 291.20111083984375 [10]
```

The GOF rasterizer returns 9 channels in this fork, while the SuGaR/3DGS rasterizer returns 3 color channels. This matches the fact that GOF's rasterizer is customized beyond the original 3DGS path.

## Next

다음 단계는 `code/wind3dgs/extractors/` 아래에 external extractor adapter를 만들고, 동일한 입력 asset을 GOF/SuGaR runner로 넘겨 mesh output path와 metadata를 표준화하는 것이다.
