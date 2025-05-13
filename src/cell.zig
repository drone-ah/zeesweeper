const std = @import("std");
const rl = @import("raylib");
const Self = @This();

row: u16,
col: u16,
size: u16,
zee: bool = false,
revealed: bool = false,
marked: bool = false,

pub fn draw(self: *const Self) void {
    rl.drawRectangleLines(self.col * self.size, self.row * self.size, self.size, self.size, .gray);
}
