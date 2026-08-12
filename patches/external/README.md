# External patch archive

이 폴더는 `external/` 아래 수정된 third-party checkout을 재현하기 위한 원본 `git diff --binary` patch를 보존한다. Build directory, cache와 untracked install metadata는 포함하지 않는다.

적용 순서는 `manifests/external_dependencies.json`을 따른다.

```bash
git -C <checkout> checkout <base_commit>
git -C <checkout> apply --check <absolute_patch_path>
git -C <checkout> apply <absolute_patch_path>
```

주의 사항:

- SIBR core와 그 내부 CudaRasterizer는 서로 다른 Git checkout이므로 patch도 별도로 적용한다.
- GOF patch에는 당시 worktree를 그대로 보존하기 위해 한 개의 generated `PKG-INFO` 변경이 포함되어 있다. 기능 patch를 정제할 때는 이를 별도 metadata 변경으로 취급한다.
- Patch를 적용하기 전 각 checkout이 manifest의 base commit과 일치하는지 확인한다.
- 현재 patch SHA-256은 manifest와 일치하며, 각 base commit의 clean `git archive`에 대한 `git apply --check`도 통과했다. 실제 build/runtime 검증은 TD00 외부 도구 재현 test에서 별도로 수행한다.
- 이 파일들은 third-party worktree의 원본 바이트를 보존하는 archive다. 따라서 CRLF와 trailing whitespace를 임의로 정규화하지 않으며, 저장소의 일반 `git diff --check`에서는 `patches/external/*.patch`만 제외한다. 대신 SHA-256과 clean-base `git apply --check`로 무결성을 검증한다.
