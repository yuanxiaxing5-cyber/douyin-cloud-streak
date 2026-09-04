@echo off
cd /d "C:\Users\Admin\Doubao\chats\2026-09-04\new-chat\douyin-cloud-streak"
set AUTH_TOKEN=douyin_local_2026
set PORT=8000
start "" /min "venv\Scripts\python.exe" app.py
exit
