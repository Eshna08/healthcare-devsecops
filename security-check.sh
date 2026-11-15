#!/bin/bash

echo "===== DEVSECOPS SECURITY CHECK ====="

FAILED=0

echo "[1] Checking required files..."
for file in index.html Dockerfile; do
    if [ -f "$file" ]; then
        echo "PASS: $file exists"
    else
        echo "FAIL: $file missing"
        FAILED=1
    fi
done

echo "[2] Checking Dockerfile..."
if grep -qi "FROM nginx:alpine" Dockerfile; then
    echo "PASS: Lightweight Nginx base image"
else
    echo "FAIL: Expected Nginx Alpine base image"
    FAILED=1
fi

echo "[3] Checking for privileged container configuration..."
if grep -qiE 'privileged[[:space:]]*=[[:space:]]*true' Dockerfile; then
    echo "FAIL: Privileged configuration detected"
    FAILED=1
else
    echo "PASS: No privileged configuration detected"
fi

echo "[4] Checking for hardcoded secrets..."
if grep -qiE '(password|api_key|secret)[[:space:]]*[:=][[:space:]]*["'\''][^"'\'']+' index.html; then
    echo "FAIL: Possible hardcoded secret detected"
    FAILED=1
else
    echo "PASS: No obvious hardcoded secrets detected"
fi

echo "===== SECURITY CHECK COMPLETE ====="

exit $FAILED
