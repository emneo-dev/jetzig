const std = @import("std");
const util = @import("../../util.zig");

const jetquery = @import("jetquery");

const help_msg =
    \\Generate a new Seeder. Seeders is a way to set up some inital data for your application.
    \\
    \\Example:
    \\
    \\  jetzig generate seeder iguana
    \\
    \\  More information: https://www.jetzig.dev/documentation/sections/database/command_line_tools
    \\
;

/// Run the seeder generator. Create a seed in `src/app/database/seeders/`
pub fn run(allocator: std.mem.Allocator, cwd: std.fs.Dir, args: [][]const u8, help: bool) !void {
    if (help) {
        try util.stdout.print(help_msg, .{});
        return;
    }

    if (args.len < 1) {
        try util.stderr.print(help_msg, .{});
        return error.JetzigCommandError;
    }

    const name = args[0];

    const seeders_dir = try cwd.makeOpenPath(
        try std.fs.path.join(allocator, &.{ "src", "app", "database", "seeders" }),
        .{},
    );
    const seed = jetquery.Seeder.init(
        allocator,
        name,
        .{
            .seeders_path = try seeders_dir.realpathAlloc(allocator, "."),
        },
    );
    const path = try seed.save();

    try util.stdout.print("Saved seed: {s}", .{path});
}
