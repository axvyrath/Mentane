const std = @import("std");

pub fn main() std.os.uefi.Error!void {
    const con_out = std.os.uefi.system_table.con_out;

    const msg = std.unicode.utf8ToUtf16LeStringLiteral("Hello World!");

    _ = try con_out.?.outputString(msg);
}
