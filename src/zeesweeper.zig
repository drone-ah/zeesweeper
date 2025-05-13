const std = @import("std");
const Cell = @import("cell.zig");

const Self = @This();

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
        .cells = cells,
    };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    for (self.cells) |col| {
        allocator.free(col);
    }

    allocator.free(self.cells);
}

pub fn draw(self: *Self) void {
    for (self.cells) |cols| {
        for (cols) |cell| {
            cell.draw();
        }
    }
}
