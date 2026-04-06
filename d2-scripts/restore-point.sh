#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  restore-point.sh <command> --target <path> [--snapshot-root <path>] [--archive latest|path|name] [--limit <n>]

Commands:
  check
  create
  list
  preview-restore
  apply-restore
  closeout
EOF
}

fail() {
  printf 'ERROR=%s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing required command: $1"
}

resolve_existing_path() {
  [ -e "$1" ] || fail "Path not found: $1"
  (cd "$1" >/dev/null 2>&1 && pwd -P)
}

resolve_or_create_directory() {
  mkdir -p "$1"
  (cd "$1" >/dev/null 2>&1 && pwd -P)
}

get_target_slug() {
  basename "$1"
}

timestamp_now() {
  date -u +"%Y%m%d-%H%M%S"
}

get_target_header_info() {
  TARGET_NAME="Unknown"
  TARGET_TYPE="generic-folder"
  TARGET_VERSION="Unknown"
  TARGET_MAIN_FILE="Unknown"

  if [ -f "$TARGET_PATH/style.css" ] && grep -q 'Theme Name:' "$TARGET_PATH/style.css"; then
    TARGET_NAME=$(sed -n 's/^.*Theme Name:[[:space:]]*//p' "$TARGET_PATH/style.css" | head -n 1 | sed 's/[[:space:]]*$//')
    TARGET_VERSION=$(sed -n 's/^.*Version:[[:space:]]*//p' "$TARGET_PATH/style.css" | head -n 1 | sed 's/[[:space:]]*$//')
    [ -n "$TARGET_VERSION" ] || TARGET_VERSION="Unknown"
    TARGET_TYPE="theme"
    TARGET_MAIN_FILE="style.css"
    return
  fi

  for php_file in "$TARGET_PATH"/*.php; do
    [ -f "$php_file" ] || continue

    if grep -q 'Plugin Name:' "$php_file"; then
      TARGET_NAME=$(sed -n 's/^.*Plugin Name:[[:space:]]*//p' "$php_file" | head -n 1 | sed 's/[[:space:]]*$//')
      TARGET_VERSION=$(sed -n 's/^.*Version:[[:space:]]*//p' "$php_file" | head -n 1 | sed 's/[[:space:]]*$//')
      [ -n "$TARGET_VERSION" ] || TARGET_VERSION="Unknown"
      TARGET_TYPE="plugin"
      TARGET_MAIN_FILE=$(basename "$php_file")
      return
    fi
  done

  if [ -f "$TARGET_PATH/_project-context.md" ]; then
    project_name=$(sed -n 's/^- Project Name:[[:space:]]*//p' "$TARGET_PATH/_project-context.md" | head -n 1 | sed 's/[[:space:]]*$//')
    if [ -n "$project_name" ]; then
      TARGET_NAME="$project_name"
      TARGET_TYPE="site-project"
      TARGET_MAIN_FILE="_project-context.md"
    fi
  fi
}

get_git_info() {
  GIT_AVAILABLE=false
  IS_GIT_REPO=false
  GIT_REPO_ROOT='N/A'
  GIT_BRANCH='N/A'
  GIT_COMMIT='N/A'
  WORKTREE_STATE='not-a-repo'
  MODIFIED_COUNT=0
  DELETED_COUNT=0
  UNTRACKED_COUNT=0
  RENAMED_COUNT=0
  GIT_CHECKPOINT_ELIGIBLE=false

  if ! command -v git >/dev/null 2>&1; then
    return
  fi

  GIT_AVAILABLE=true

  if ! git -C "$TARGET_PATH" rev-parse --show-toplevel >/dev/null 2>&1; then
    return
  fi

  IS_GIT_REPO=true
  GIT_REPO_ROOT=$(git -C "$TARGET_PATH" rev-parse --show-toplevel)
  GIT_BRANCH=$(git -C "$TARGET_PATH" branch --show-current 2>/dev/null || printf 'N/A')
  GIT_COMMIT=$(git -C "$TARGET_PATH" rev-parse HEAD 2>/dev/null || printf 'N/A')

  status_output=$(git -C "$TARGET_PATH" status --porcelain=v1 --untracked-files=all 2>/dev/null || true)

  while IFS= read -r status_line; do
    [ -n "$status_line" ] || continue
    status_code=$(printf '%s' "$status_line" | cut -c 1-2)

    if [ "$status_code" = '??' ]; then
      UNTRACKED_COUNT=$((UNTRACKED_COUNT + 1))
      continue
    fi

    case "$status_code" in
      *R*) RENAMED_COUNT=$((RENAMED_COUNT + 1)) ;;
      *D*) DELETED_COUNT=$((DELETED_COUNT + 1)) ;;
      *) MODIFIED_COUNT=$((MODIFIED_COUNT + 1)) ;;
    esac
  done <<EOF
$status_output
EOF

  change_count=$((MODIFIED_COUNT + DELETED_COUNT + UNTRACKED_COUNT + RENAMED_COUNT))

  if [ "$change_count" -eq 0 ]; then
    WORKTREE_STATE='clean'
    GIT_CHECKPOINT_ELIGIBLE=true
  else
    WORKTREE_STATE='dirty'
  fi
}

get_snapshot_directory() {
  printf '%s/%s\n' "$SNAPSHOT_ROOT" "$PLUGIN_SLUG"
}

get_snapshot_archives() {
  local snapshot_dir=$1

  if [ ! -d "$snapshot_dir" ]; then
    return
  fi

  find "$snapshot_dir" -maxdepth 1 -type f -name '*.zip' -print | LC_ALL=C sort -r
}

resolve_archive_selection() {
  local snapshot_dir=$1
  local selection=$2

  if [ "$selection" != 'latest' ]; then
    if [ -f "$selection" ]; then
      (cd "$(dirname "$selection")" >/dev/null 2>&1 && printf '%s/%s\n' "$(pwd -P)" "$(basename "$selection")")
      return
    fi

    if [ -f "$snapshot_dir/$selection" ]; then
      printf '%s/%s\n' "$snapshot_dir" "$selection"
      return
    fi

    if [ -f "$snapshot_dir/$selection.zip" ]; then
      printf '%s/%s.zip\n' "$snapshot_dir" "$selection"
      return
    fi

    fail "Restore point not found: $selection"
  fi

  latest_archive=$(get_snapshot_archives "$snapshot_dir" | head -n 1 || true)
  [ -n "$latest_archive" ] || fail "No restore points found in $snapshot_dir"
  printf '%s\n' "$latest_archive"
}

new_temp_dir() {
  mktemp -d "${TMPDIR:-/tmp}/restore-point.XXXXXX"
}

build_file_list() {
  local root=$1

  (cd "$root" >/dev/null 2>&1 && find . -type f -print | sed 's#^\./##' | LC_ALL=C sort)
}

compare_archive_to_target() {
  require_command unzip

  local archive_path=$1
  local stage_dir
  stage_dir=$(new_temp_dir)
  unzip -q "$archive_path" -d "$stage_dir"

  local snapshot_list current_list restore_only_list delete_list common_list replace_list
  snapshot_list=$(mktemp "${TMPDIR:-/tmp}/restore-point-snapshot.XXXXXX")
  current_list=$(mktemp "${TMPDIR:-/tmp}/restore-point-current.XXXXXX")
  restore_only_list=$(mktemp "${TMPDIR:-/tmp}/restore-point-restore.XXXXXX")
  delete_list=$(mktemp "${TMPDIR:-/tmp}/restore-point-delete.XXXXXX")
  common_list=$(mktemp "${TMPDIR:-/tmp}/restore-point-common.XXXXXX")
  replace_list=$(mktemp "${TMPDIR:-/tmp}/restore-point-replace.XXXXXX")

  build_file_list "$stage_dir" > "$snapshot_list"
  build_file_list "$TARGET_PATH" > "$current_list"

  comm -23 "$snapshot_list" "$current_list" > "$restore_only_list"
  comm -13 "$snapshot_list" "$current_list" > "$delete_list"
  comm -12 "$snapshot_list" "$current_list" > "$common_list"

  : > "$replace_list"
  while IFS= read -r relative_path; do
    [ -n "$relative_path" ] || continue

    if ! cmp -s "$stage_dir/$relative_path" "$TARGET_PATH/$relative_path"; then
      printf '%s\n' "$relative_path" >> "$replace_list"
    fi
  done < "$common_list"

  SNAPSHOT_FILE_COUNT=$(wc -l < "$snapshot_list" | tr -d ' ')
  CURRENT_FILE_COUNT=$(wc -l < "$current_list" | tr -d ' ')
  RESTORE_ONLY_COUNT=$(wc -l < "$restore_only_list" | tr -d ' ')
  DELETE_COUNT=$(wc -l < "$delete_list" | tr -d ' ')
  REPLACE_COUNT=$(wc -l < "$replace_list" | tr -d ' ')
  RESTORE_ONLY_LIST=$restore_only_list
  DELETE_LIST=$delete_list
  REPLACE_LIST=$replace_list
  COMPARE_STAGE_DIR=$stage_dir
  SNAPSHOT_LIST_FILE=$snapshot_list
  CURRENT_LIST_FILE=$current_list
  COMMON_LIST_FILE=$common_list
}

cleanup_compare_artifacts() {
  rm -rf "$COMPARE_STAGE_DIR" "$SNAPSHOT_LIST_FILE" "$CURRENT_LIST_FILE" "$COMMON_LIST_FILE" "$RESTORE_ONLY_LIST" "$DELETE_LIST" "$REPLACE_LIST"
}

print_list_section() {
  local title=$1
  local list_file=$2
  local max_items=$3
  local count
  count=$(wc -l < "$list_file" | tr -d ' ')

  printf '\n%s:\n' "$title"

  if [ "$count" -eq 0 ]; then
    printf '%s\n' '- none'
    return
  fi

  awk -v limit="$max_items" 'NR <= limit { print "- " $0 }' "$list_file"

  if [ "$count" -gt "$max_items" ]; then
    printf '%s\n' "- ... $((count - max_items)) more"
  fi
}

write_sidecar_file() {
  local sidecar_path=$1
  local archive_path=$2
  local snapshot_dir=$3
  local file_count=$4
  local archive_size archive_hash created_at

  archive_size=$(wc -c < "$archive_path" | tr -d ' ')

  if command -v sha256sum >/dev/null 2>&1; then
    archive_hash=$(sha256sum "$archive_path" | awk '{print $1}')
  elif command -v shasum >/dev/null 2>&1; then
    archive_hash=$(shasum -a 256 "$archive_path" | awk '{print $1}')
  else
    archive_hash='Unavailable'
  fi

  created_at=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

  cat > "$sidecar_path" <<EOF
Restore Point Metadata
======================

Created At: $created_at
Target Folder: $PLUGIN_SLUG
Target Name: $TARGET_NAME
Target Type: $TARGET_TYPE
Version: $TARGET_VERSION
Main Entry File: $TARGET_MAIN_FILE
Target Path: $TARGET_PATH
Snapshot Root: $SNAPSHOT_ROOT
Snapshot Folder: $snapshot_dir
Archive Path: $archive_path
Archive Size Bytes: $archive_size
Archive SHA256: $archive_hash
Source File Count: $file_count
Git Repository: $( [ "$IS_GIT_REPO" = true ] && printf 'Yes' || printf 'No' )
Git Branch: $GIT_BRANCH
Git Commit: $GIT_COMMIT
Worktree State: $WORKTREE_STATE

Notes:
- This is an exact full-folder snapshot of the target path.
- Use preview-restore before apply-restore whenever possible.
- Re-run SESSION_BOOTSTRAP_PROMPT.md after a rollback so chat context matches the restored codebase.
EOF

  printf 'SIDECAR_PATH=%s\n' "$sidecar_path"
  printf 'ARCHIVE_SHA256=%s\n' "$archive_hash"
}

COMMAND=${1:-}
[ -n "$COMMAND" ] || { usage; exit 1; }
shift || true

TARGET_PATH=''
SNAPSHOT_ROOT=''
ARCHIVE='latest'
LIMIT=25

while [ $# -gt 0 ]; do
  case "$1" in
    --target)
      TARGET_PATH=${2:-}
      shift 2
      ;;
    --snapshot-root)
      SNAPSHOT_ROOT=${2:-}
      shift 2
      ;;
    --archive)
      ARCHIVE=${2:-}
      shift 2
      ;;
    --limit)
      LIMIT=${2:-25}
      shift 2
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

[ -n "$TARGET_PATH" ] || fail 'Target path is required.'
TARGET_PATH=$(resolve_existing_path "$TARGET_PATH")
PLUGIN_SLUG=$(get_target_slug "$TARGET_PATH")
get_target_header_info
get_git_info

case "$COMMAND" in
  check)
    snapshot_directory='N/A'
    latest_archive=''

    if [ -n "$SNAPSHOT_ROOT" ]; then
      snapshot_directory=$(get_snapshot_directory)
      if [ -d "$snapshot_directory" ]; then
        latest_archive=$(get_snapshot_archives "$snapshot_directory" | head -n 1 || true)
      fi
    fi

    file_count=$(find "$TARGET_PATH" -type f | wc -l | tr -d ' ')

    printf 'MODE=check\n'
    printf 'TARGET_PATH=%s\n' "$TARGET_PATH"
    printf 'TARGET_SLUG=%s\n' "$PLUGIN_SLUG"
    printf 'TARGET_NAME=%s\n' "$TARGET_NAME"
    printf 'TARGET_TYPE=%s\n' "$TARGET_TYPE"
    printf 'TARGET_VERSION=%s\n' "$TARGET_VERSION"
    printf 'MAIN_ENTRY_FILE=%s\n' "$TARGET_MAIN_FILE"
    printf 'FILE_COUNT=%s\n' "$file_count"
    printf 'SNAPSHOT_ROOT=%s\n' "$SNAPSHOT_ROOT"
    printf 'SNAPSHOT_DIRECTORY=%s\n' "$snapshot_directory"
    printf 'LATEST_ARCHIVE=%s\n' "$latest_archive"
    printf 'IS_GIT_REPO=%s\n' "$IS_GIT_REPO"
    printf 'GIT_BRANCH=%s\n' "$GIT_BRANCH"
    printf 'GIT_COMMIT=%s\n' "$GIT_COMMIT"
    printf 'WORKTREE_STATE=%s\n' "$WORKTREE_STATE"
    printf 'MODIFIED_COUNT=%s\n' "$MODIFIED_COUNT"
    printf 'DELETED_COUNT=%s\n' "$DELETED_COUNT"
    printf 'UNTRACKED_COUNT=%s\n' "$UNTRACKED_COUNT"
    printf 'RENAMED_COUNT=%s\n' "$RENAMED_COUNT"
    printf 'GIT_CHECKPOINT_ELIGIBLE=%s\n' "$GIT_CHECKPOINT_ELIGIBLE"
    ;;

  create)
    [ -n "$SNAPSHOT_ROOT" ] || fail 'Snapshot root is required for create.'
    require_command zip
    SNAPSHOT_ROOT=$(resolve_or_create_directory "$SNAPSHOT_ROOT")
    snapshot_directory=$(resolve_or_create_directory "$(get_snapshot_directory)")
    timestamp=$(timestamp_now)
    base_name="$PLUGIN_SLUG-$timestamp"
    archive_path="$snapshot_directory/$base_name.zip"
    sidecar_path="$snapshot_directory/$base_name.txt"
    file_count=$(find "$TARGET_PATH" -type f | wc -l | tr -d ' ')

    (
      cd "$TARGET_PATH" >/dev/null 2>&1
      zip -qr "$archive_path" .
    )

    printf 'MODE=create\n'
    printf 'TARGET_PATH=%s\n' "$TARGET_PATH"
    printf 'SNAPSHOT_ROOT=%s\n' "$SNAPSHOT_ROOT"
    printf 'SNAPSHOT_DIRECTORY=%s\n' "$snapshot_directory"
    printf 'ARCHIVE_PATH=%s\n' "$archive_path"
    printf 'FILE_COUNT=%s\n' "$file_count"
    printf 'IS_GIT_REPO=%s\n' "$IS_GIT_REPO"
    printf 'GIT_BRANCH=%s\n' "$GIT_BRANCH"
    printf 'GIT_COMMIT=%s\n' "$GIT_COMMIT"
    printf 'WORKTREE_STATE=%s\n' "$WORKTREE_STATE"

    write_sidecar_file "$sidecar_path" "$archive_path" "$snapshot_directory" "$file_count"
    ;;

  list)
    [ -n "$SNAPSHOT_ROOT" ] || fail 'Snapshot root is required for list.'
    SNAPSHOT_ROOT=$(resolve_or_create_directory "$SNAPSHOT_ROOT")
    snapshot_directory=$(get_snapshot_directory)

    printf 'MODE=list\n'
    printf 'SNAPSHOT_DIRECTORY=%s\n' "$snapshot_directory"

    archive_count=0
    while IFS= read -r archive_path; do
      [ -n "$archive_path" ] || continue
      archive_count=$((archive_count + 1))
      sidecar_path=${archive_path%.zip}.txt
      if [ -f "$sidecar_path" ]; then
        printf -- '- %s | sidecar=present\n' "$archive_path"
      else
        printf -- '- %s | sidecar=missing\n' "$archive_path"
      fi
    done <<EOF
$(get_snapshot_archives "$snapshot_directory")
EOF
    printf 'RESTORE_POINT_COUNT=%s\n' "$archive_count"
    ;;

  preview-restore)
    [ -n "$SNAPSHOT_ROOT" ] || fail 'Snapshot root is required for preview-restore.'
    SNAPSHOT_ROOT=$(resolve_or_create_directory "$SNAPSHOT_ROOT")
    snapshot_directory=$(get_snapshot_directory)
    archive_path=$(resolve_archive_selection "$snapshot_directory" "$ARCHIVE")
    compare_archive_to_target "$archive_path"

    printf 'MODE=preview-restore\n'
    printf 'ARCHIVE_PATH=%s\n' "$archive_path"
    printf 'SNAPSHOT_FILE_COUNT=%s\n' "$SNAPSHOT_FILE_COUNT"
    printf 'CURRENT_FILE_COUNT=%s\n' "$CURRENT_FILE_COUNT"
    printf 'RESTORE_ONLY_COUNT=%s\n' "$RESTORE_ONLY_COUNT"
    printf 'REPLACE_COUNT=%s\n' "$REPLACE_COUNT"
    printf 'DELETE_COUNT=%s\n' "$DELETE_COUNT"
    print_list_section 'RESTORE_ONLY_FILES' "$RESTORE_ONLY_LIST" "$LIMIT"
    print_list_section 'REPLACE_FILES' "$REPLACE_LIST" "$LIMIT"
    print_list_section 'DELETE_FILES' "$DELETE_LIST" "$LIMIT"
    cleanup_compare_artifacts
    ;;

  apply-restore)
    [ -n "$SNAPSHOT_ROOT" ] || fail 'Snapshot root is required for apply-restore.'
    require_command unzip
    require_command rsync
    SNAPSHOT_ROOT=$(resolve_or_create_directory "$SNAPSHOT_ROOT")
    snapshot_directory=$(get_snapshot_directory)
    archive_path=$(resolve_archive_selection "$snapshot_directory" "$ARCHIVE")
    stage_dir=$(new_temp_dir)
    unzip -q "$archive_path" -d "$stage_dir"
    mkdir -p "$TARGET_PATH"
    rsync -a --delete "$stage_dir/" "$TARGET_PATH/"
    rm -rf "$stage_dir"
    printf 'MODE=apply-restore\n'
    printf 'ARCHIVE_PATH=%s\n' "$archive_path"
    printf 'TARGET_PATH=%s\n' "$TARGET_PATH"
    printf 'RESTORE_RESULT=success\n'
    ;;

  closeout)
    [ -n "$SNAPSHOT_ROOT" ] || fail 'Snapshot root is required for closeout.'
    SNAPSHOT_ROOT=$(resolve_or_create_directory "$SNAPSHOT_ROOT")
    snapshot_directory=$(get_snapshot_directory)
    archive_path=$(resolve_archive_selection "$snapshot_directory" 'latest')
    compare_archive_to_target "$archive_path"

    printf 'MODE=closeout\n'
    printf 'IS_GIT_REPO=%s\n' "$IS_GIT_REPO"
    printf 'WORKTREE_STATE=%s\n' "$WORKTREE_STATE"
    printf 'MODIFIED_COUNT=%s\n' "$MODIFIED_COUNT"
    printf 'DELETED_COUNT=%s\n' "$DELETED_COUNT"
    printf 'UNTRACKED_COUNT=%s\n' "$UNTRACKED_COUNT"
    printf 'RENAMED_COUNT=%s\n' "$RENAMED_COUNT"
    printf 'ARCHIVE_PATH=%s\n' "$archive_path"
    printf 'SNAPSHOT_FILE_COUNT=%s\n' "$SNAPSHOT_FILE_COUNT"
    printf 'CURRENT_FILE_COUNT=%s\n' "$CURRENT_FILE_COUNT"
    printf 'RESTORE_ONLY_COUNT=%s\n' "$RESTORE_ONLY_COUNT"
    printf 'REPLACE_COUNT=%s\n' "$REPLACE_COUNT"
    printf 'DELETE_COUNT=%s\n' "$DELETE_COUNT"
    print_list_section 'RESTORE_ONLY_FILES' "$RESTORE_ONLY_LIST" "$LIMIT"
    print_list_section 'REPLACE_FILES' "$REPLACE_LIST" "$LIMIT"
    print_list_section 'DELETE_FILES' "$DELETE_LIST" "$LIMIT"
    cleanup_compare_artifacts
    ;;

  *)
    usage
    exit 1
    ;;
esac