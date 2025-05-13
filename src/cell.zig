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
    const x: u16 = self.col * self.size;
    const y: u16 = self.row * self.size;

    rl.drawRectangleLines(x, y, self.size, self.size, .gray);

    const radius = @divFloor(self.size, 2);
    const centerx = x + radius;
    const centery = y + radius;

    if (self.zee) {
        rl.drawCircle(centerx, centery, @floatFromInt(radius), .orange);
    }
}
