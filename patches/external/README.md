# External patch archive

이 폴더는 `external/` 아래 수정된 third-party checkout을 재현하기 위한 원본 `git diff --binary` patch를 보존한다. Build directory, cache와 untracked install metadata는 포함하지 않는다.

적용 순서, origin, base commit, patch SHA-256과 허용 변경 경로는
`manifests/external_dependencies.json`을 따른다.

## 안전한 재현 절차

기존 `external/` checkout은 사용자 작업을 포함할 수 있으므로 그 자리에서 branch를 바꾸거나
patch를 적용하지 않는다. 먼저 manifest와 대상 경로를 확인한 뒤, 별도의 clean clone 또는
clean worktree를 준비한다. 아래 `<clean_checkout>`은 기존 checkout과 다른 명시적인 경로여야 한다.

```bash
git clone --no-checkout <manifest_origin> <clean_checkout>
git -C <clean_checkout> checkout --detach <manifest_base_commit>
git -C <clean_checkout> status --porcelain
sha256sum <absolute_patch_path>
git -C <clean_checkout> apply --check <absolute_patch_path>
git -C <clean_checkout> apply <absolute_patch_path>
git -C <clean_checkout> status --short
```

`status --porcelain` 결과가 비어 있지 않거나 SHA-256이 manifest와 다르면 patch를 적용하지
않는다. 적용 후 변경 경로가 manifest의 `modified_paths`와 허용된 generated metadata 범위를
벗어나면 중단하고 원인을 확인한다. Build/runtime 검증 결과는 해당 experiment 기록에 남긴다.

주의 사항:

- SIBR core와 그 내부 CudaRasterizer는 서로 다른 Git checkout이므로 patch도 별도로 적용한다.
- GOF patch에는 당시 worktree를 그대로 보존하기 위해 한 개의 generated `PKG-INFO` 변경이 포함되어 있다. 기능 patch를 정제할 때는 이를 별도 metadata 변경으로 취급한다.
- Patch를 적용하기 전 각 checkout이 manifest의 base commit과 일치하는지 확인한다.
- 기존 dirty checkout에서 `checkout`, `reset`, `clean`, stash, `pull` 또는 patch 적용을 수행하지 않는다.
- 외부 checkout을 임의로 최신화하지 않으며 manifest 갱신은 별도 검토 작업으로 취급한다.
- 외부 저장소에 commit 또는 push하지 않는다. 사용자가 대상 remote와 목적을 명시적으로 승인한 경우에만 별도 작업으로 수행한다.
- 현재 patch SHA-256은 manifest와 일치하며, 각 base commit의 clean `git archive`에 대한 `git apply --check`도 통과했다. 실제 build/runtime 검증은 TD00 외부 도구 재현 test에서 별도로 수행한다.
- 이 파일들은 third-party worktree의 원본 바이트를 보존하는 archive다. 따라서 CRLF와 trailing whitespace를 임의로 정규화하지 않으며, 저장소의 일반 `git diff --check`에서는 `patches/external/*.patch`만 제외한다. 대신 SHA-256과 clean-base `git apply --check`로 무결성을 검증한다.
