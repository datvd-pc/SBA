# Solo Business Assistant

Bộ cài khởi động nhẹ cho trợ lý kinh doanh cá nhân: cài OpenClaw, mở wizard kết nối model và bot chat, rồi tạo file hồ sơ doanh nghiệp Markdown trên máy người dùng.

## Cài nhanh

### Windows 10/11

Mở PowerShell:

```powershell
irm https://raw.githubusercontent.com/datvd-pc/SBA/main/install.ps1 | iex
```

### macOS / Linux

Mở Terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/datvd-pc/SBA/main/install.sh | sh
```

Chỉ chạy script từ repo mà người dùng tin tưởng. Có thể clone repo và đọc script trước khi chạy.

## Sau khi cài

1. Trong wizard, chọn model/provider và kết nối Telegram. Nên bắt đầu với Telegram.
2. Điền `COMPANY_PROFILE.md` trong workspace OpenClaw.
3. Giao việc qua chat: lập kế hoạch, chuẩn bị nội dung chăm sóc khách, tạo nhắc việc hoặc soạn bản nháp.
4. Duyệt trước khi gửi tin, đăng bài, chốt giá hoặc hứa hẹn với khách/đối tác.

Workspace mặc định: Windows `%USERPROFILE%\.openclaw\workspace`; macOS/Linux `~/.openclaw/workspace`.

## Đăng nhập model không cần API key

- **OpenAI Codex / ChatGPT:** đăng nhập bằng OAuth trong OpenClaw; model dùng hạn mức Codex của tài khoản đủ điều kiện.
- **Claude Code:** cài Claude Code và đăng nhập trên cùng máy, cùng tài khoản hệ điều hành chạy OpenClaw Gateway; chọn Claude CLI khi cấu hình. Claude Code tự quản lý phiên đăng nhập. Lượt dùng chia sẻ hạn mức của gói Claude.
- **Gemini bằng tài khoản Google:** Gemini CLI có đăng nhập Google riêng, nhưng OpenClaw hiện chưa hỗ trợ thiết lập OAuth Gemini CLI mới. Muốn gọi Gemini trực tiếp trong OpenClaw cần API key từ AI Studio hoặc cấu hình Vertex AI.

OpenClaw không cần và không nên nhận mật khẩu tài khoản. Hãy đăng nhập qua trang OAuth hoặc CLI chính thức. Đăng nhập model AI tách biệt với cấp quyền Google Drive/Calendar; hai dịch vụ này vẫn cần kết nối riêng.
## Phạm vi bản khởi động

Repo này tự cài OpenClaw Gateway và hướng dẫn trợ lý. Model chạy qua provider người dùng chọn; repo không tải model cục bộ. Google Drive, Google Calendar, CRM và Zalo OA cần kết nối riêng sau khi cài. Zalo Bot và Zalo OA là hai tích hợp khác nhau.

Không cài Docker, ERPNext hay database để giữ bộ cài nhẹ. Khi cần CRM, đơn hàng, kho hoặc công nợ có cấu trúc, có thể bổ sung hệ thống riêng.

`COMPANY_PROFILE.md` nằm trên máy người dùng và đã bị Git bỏ qua. Không đưa hồ sơ khách hàng, bảng giá nội bộ, hợp đồng, khóa API hoặc token vào repo công khai. Nội dung hồ sơ có thể được gửi tới nhà cung cấp model để xử lý.

Tài liệu: [Cài đặt OpenClaw](https://docs.openclaw.ai/install) · [Workspace](https://docs.openclaw.ai/concepts/agent-workspace) · [Windows](https://docs.openclaw.ai/platforms/windows)

