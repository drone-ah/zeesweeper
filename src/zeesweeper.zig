const rl = @import("raylib");
const std = @import("std");
const Cell = @import("cell.zig");

const Self = @This();

const num_zees = 10;

rows: usize,
cols: usize,
size: u8,
cells: [][]Cell,

pub fn init(allocator: std.mem.Allocator, width: u16, height: u16, size: u8) !Self {
    const rows = @divFloor(height, size);
    const cols = @divFloor(width, size);

    const cells = try allocator.alloc([]Cell, cols);
    for (cells, 0..) |*col, x| {
        col.* = try allocator.alloc(Cell, rows);
        for (col.*, 0..) |*cell, y| {
            cell.* = Cell{
                .col = @intCast(x),
                .row = @intCast(y),
                .size = size,
            };
        }
    }

    return .{
        .rows = rows,
        .cols = cols,
        .cells = cells,
        .size = size,
    };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    for (self.cells) |col| {
        allocator.free(col);
    }

    allocator.free(self.cells);
}

pub fn populate(self: *Self) void {
    self.fillZees();
    self.countZees();
}

fn fillZees(self: *Self) void {
    const rnd = std.crypto.random;
    var zees: usize = 0;
    while (zees < num_zees) {
        const x = rnd.uintAtMost(u16, @intCast(self.rows - 1));
        const y = rnd.uintAtMost(u16, @intCast(self.cols - 1));

        if (!self.cells[x][y].zee) {
            self.cells[x][y].zee = true;
            zees += 1;
        }
    }
}

fn countZees(self: *Self) void {
    for (self.cells) |*col| {
        for (col.*) |*cell| {
            if (!cell.zee) {
                cell.countZees(self.cells);
            }
        }
    }
}

fn gameOver(self: *Self) void {
    for (self.cells) |*col| {
        for (col.*) |*cell| {
            cell.revealed = true;
        }
    }
}

pub fn draw(self: *Self) void {
    if (rl.isMouseButtonPressed(.left)) {
        const col: usize = @intCast(@divFloor(rl.getMouseX(), self.size));
        const row: usize = @intCast(@divFloor(rl.getMouseY(), self.size));
        self.cells[col][row].reveal(self.cells);
        if (self.cells[col][row].zee) {
            self.gameOver();
        }
    }

    for (self.cells) |cols| {
        for (cols) |cell| {
            cell.draw();
        }
    }
}
