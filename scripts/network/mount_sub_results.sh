#!/usr/bin/env bash
# 서브컴 WSL2에서 sudo bash로 실행한다. 암호는 로컬 대화형으로만 입력한다.
set -euo pipefail
[[ $EUID == 0 ]] || { echo 'sudo bash로 실행하세요.' >&2; exit 1; }
RESULTS_SERVER="${1:-192.168.0.3}"
RESULTS_USER="${2:-choi}"
RESULTS_MOUNT=/mnt/wind3dgs-sub-results
RESULTS_SOURCE="//$RESULTS_SERVER/wind3dgs-sub-results"
RESULTS_CREDENTIAL=/etc/wind3dgs/smb.credentials
for RESULTS_PATH in "$RESULTS_MOUNT" /etc/wind3dgs "$RESULTS_CREDENTIAL"; do
    [[ ! -L "$RESULTS_PATH" ]] || { echo '설정 대상 symlink는 사용하지 않습니다.' >&2; exit 1; }
done
command -v mount.cifs >/dev/null || { echo 'cifs-utils 설치가 필요합니다.' >&2; exit 1; }
RESULTS_UID=$(id -u "$RESULTS_USER")
RESULTS_GID=$(id -g "$RESULTS_USER")
if mountpoint -q "$RESULTS_MOUNT"; then
    [[ $(findmnt -rn -M "$RESULTS_MOUNT" -o SOURCE) == "$RESULTS_SOURCE" ]] || { echo '다른 공유가 이미 연결되어 있습니다.' >&2; exit 1; }
    echo '결과 공유가 이미 연결되어 있습니다.'
    exit 0
fi
if [[ -e "$RESULTS_MOUNT" ]] && [[ -n $(find "$RESULTS_MOUNT" -mindepth 1 -maxdepth 1 -print -quit) ]]; then
    echo '마운트 위치에 기존 파일이 있어 중단합니다.' >&2; exit 1
fi
if awk '$2 == "/mnt/wind3dgs-sub-results" { found=1 } END {exit !found}' /etc/fstab; then
    echo '기존 fstab 결과 공유 항목을 확인한 뒤 sudo mount /mnt/wind3dgs-sub-results를 실행하세요.' >&2
    exit 1
fi
install -d -m 700 /etc/wind3dgs
if [[ ! -f "$RESULTS_CREDENTIAL" ]]; then
    umask 077
    read -r -s -p "Samba $RESULTS_USER 암호: " RESULTS_PASSWORD
    printf '\n'
    [[ -n "$RESULTS_PASSWORD" ]] || { echo '암호가 비어 있습니다.' >&2; exit 1; }
    printf 'username=%s\npassword=%s\n' "$RESULTS_USER" "$RESULTS_PASSWORD" > "$RESULTS_CREDENTIAL"
    unset RESULTS_PASSWORD
fi
[[ ! -L "$RESULTS_CREDENTIAL" ]] || { echo '자격 증명 symlink는 사용하지 않습니다.' >&2; exit 1; }
chown root:root "$RESULTS_CREDENTIAL"
chmod 600 "$RESULTS_CREDENTIAL"
install -d -m 555 "$RESULTS_MOUNT"
RESULTS_OPTIONS="credentials=$RESULTS_CREDENTIAL,port=1445,vers=3.0,rw,uid=$RESULTS_UID,gid=$RESULTS_GID,nosuid,nodev,_netdev,nofail"
mount -t cifs "$RESULTS_SOURCE" "$RESULTS_MOUNT" -o "$RESULTS_OPTIONS"
mountpoint -q "$RESULTS_MOUNT"
cp -a /etc/fstab "/etc/fstab.before-wind3dgs-results-$(date +%Y%m%d%H%M%S)"
printf '\n%s %s cifs %s 0 0\n' "$RESULTS_SOURCE" "$RESULTS_MOUNT" "$RESULTS_OPTIONS" >> /etc/fstab
findmnt -rn -M "$RESULTS_MOUNT" -o TARGET,SOURCE,FSTYPE
printf '%s\n' '결과 공유 연결 완료. 출력은 /mnt/wind3dgs-sub-results/<고유 run ID>로 지정하세요.'
printf '%s\n' '실행 전 mountpoint -q /mnt/wind3dgs-sub-results로 연결 여부를 확인하세요.'
