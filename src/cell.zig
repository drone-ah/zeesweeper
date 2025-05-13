const std = @import("std");
const rl = @import("raylib");
const Self = @This();

row: i16,
col: i16,
size: i16,
zee: bool = false,
neighbours: u8 = 0,
revealed: bool = false,
marked: bool = false,

pub fn draw(self: *const Self) void {
    const x: i16 = self.col * self.size;
    const y: i16 = self.row * self.size;

    const colour = if (self.revealed) rl.Color.gray else rl.Color.dark_gray;

    rl.drawRectangle(x, y, self.size, self.size, colour);
    rl.drawRectangleLines(x, y, self.size, self.size, .white);

    if (self.revealed) {
        const radius = @divFloor(self.size, 2);
        const centerx = x + radius;
        const centery = y + radius;

        if (self.zee) {
            rl.drawCircle(centerx, centery, @floatFromInt(radius), .orange);
        }

        if (self.neighbours > 0) {
            var buf: [3]u8 = undefined;
            const text = std.fmt.bufPrintZ(&buf, "{d}", .{self.neighbours}) catch {
                std.debug.print("Error formatting number\n", .{});
                return;
            };

            rl.drawText(std.mem.span(text.ptr), centerx, y + 5, 24, .blue);
        }
    }
}

pub fn reveal(self: *Self, cells: [][]Self) void {
    if (self.revealed) return;

    self.revealed = true;

    if (!self.zee and self.neighbours == 0) {
        // flood fill neighbours
        var i: i8 = -2;
        while (i < 1) {
            i += 1;
            var j: i8 = -2;
            while (j < 1) {
                j += 1;
                const x = self.col + i;
                if (x < 0 or x >= cells.len) continue;

                const y = self.row + j;
                if (y < 0 or y >= cells[0].len) continue;

                cells[@intCast(x)][@intCast(y)].reveal(cells);
            }
        }
    }
}

pub fn countZees(self: *Self, cells: [][]Self) void {
    var zees: u8 = 0;

    var i: i8 = -2;
    while (i < 1) {
        i += 1;
        var j: i8 = -2;
        while (j < 1) {
            j += 1;
            const x = self.col + i;
            if (x < 0 or x >= cells.len) continue;

            const y = self.row + j;
            if (y < 0 or y >= cells[0].len) continue;

            if (cells[@intCast(x)][@intCast(y)].zee) zees += 1;
        }
    }

    self.neighbours = zees;
}
