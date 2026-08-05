#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENV_PYTHON="$PROJECT_ROOT/.venv-epub/bin/python"

if [[ -x "$VENV_PYTHON" ]]; then
  PYTHON="$VENV_PYTHON"
elif command -v python3 >/dev/null 2>&1; then
  PYTHON="$(command -v python3)"
else
  echo "未找到 Python 3，请先安装 Python 3.11。" >&2
  exit 1
fi

exec "$PYTHON" "$PROJECT_ROOT/tools/epub_import.py" "$@"
