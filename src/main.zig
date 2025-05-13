// raylib-zig (c) Nikolas Wipper 2023
const std = @import("std");
const rl = @import("raylib");

const ZeeSweeper = @import("zeesweeper.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 400;
    const screenHeight = 400;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        //fail test; can't try in defer as defer is executed after we return
        if (deinit_status == .leak) @panic("MEM LEAK!!!");
    }

    var game = try ZeeSweeper.init(allocator, screenWidth, screenHeight, 30);
    game.populate();
    defer game.deinit(allocator);

    rl.initWindow(screenWidth, screenHeight, "ZeeSweeper");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.white);
        game.draw();

        //----------------------------------------------------------------------------------
    }
}
