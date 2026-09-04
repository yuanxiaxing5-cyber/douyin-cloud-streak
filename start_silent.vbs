Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Users\Admin\Doubao\chats\2026-09-04\new-chat\douyin-cloud-streak"
WshShell.Environment("Process")("AUTH_TOKEN") = "douyin_local_2026"
WshShell.Environment("Process")("PORT") = "8000"
WshShell.Run "venv\Scripts\python.exe app.py", 0, False
Set WshShell = Nothing
