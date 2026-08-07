param(
    [ValidateSet('apk', 'appbundle', 'windows', 'ios')]
    [string]$Target = 'apk',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$pubspecPath = Join-Path $repoRoot 'pubspec.yaml'
$pubspec = Get-Content -Raw $pubspecPath
$versionPattern = '(?m)^version:\s*(\d+)\.(\d+)\.(\d+)(?:\+(\d+))?\s*$'
$versionMatch = [regex]::Match($pubspec, $versionPattern)

if (-not $versionMatch.Success) {
    throw "无法从 pubspec.yaml 读取版本号。"
}

$major = [int]$versionMatch.Groups[1].Value
$minor = [int]$versionMatch.Groups[2].Value
$patch = [int]$versionMatch.Groups[3].Value + 1
$versionName = "$major.$minor.$patch"
$currentBuildNumber = if ($versionMatch.Groups[4].Success) {
    [int]$versionMatch.Groups[4].Value
} else {
    0
}
$newVersion = "$versionName+$($currentBuildNumber + 1)"
$updatedPubspec = [regex]::Replace(
    $pubspec,
    $versionPattern,
    "version: $newVersion",
    1
)

Write-Host "版本: $($versionMatch.Value.Trim()) -> $newVersion"
Write-Host "目标: flutter build $Target --release"

if ($DryRun) {
    Write-Host '预览模式，未修改 pubspec.yaml，也未执行打包。'
    exit 0
}

[System.IO.File]::WriteAllText($pubspecPath, $updatedPubspec, [System.Text.UTF8Encoding]::new($false))

Push-Location $repoRoot
try {
    & flutter build $Target --release --build-name=$versionName
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter 打包失败，退出码: $LASTEXITCODE"
    }
} finally {
    Pop-Location
}

Write-Host "打包完成，版本为 $newVersion"
