const std = @import("std");
const uefi = std.os.uefi;

pub fn main() uefi.Error!void {
    const boot_service = uefi.system_table.boot_services orelse return;

    const loaded_img = try boot_service.handleProtocol(uefi.protocol.LoadedImage, uefi.handle) orelse return;
    const device_handle = loaded_img.device_handle orelse return;

    const simple_file_sys = try boot_service.handleProtocol(uefi.protocol.SimpleFileSystem, device_handle) orelse return;
    const root = try simple_file_sys.openVolume();

    const file_name = std.unicode.utf8ToUtf16LeStringLiteral("message.txt");
    const file = try root.open(file_name, .read, .{ .read_only = true });

    var msg_buf: [256]u8 = undefined;
    const read_len = try file.read(&msg_buf);

    var msg_buf_u16: [256] u16 = undefined;
    const convert_len = std.unicode.utf8ToUtf16Le(&msg_buf_u16, msg_buf[0..read_len]) catch {return;};
    msg_buf_u16[convert_len] = 0;

    const con_out = uefi.system_table.con_out orelse return;
    _ = try con_out.outputString(msg_buf_u16[0..convert_len:0]);
}
