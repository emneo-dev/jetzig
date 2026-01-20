const std = @import("std");

const cli = @import("../../cli.zig");
const util = @import("../../util.zig");

const help_msg =
    \\Run database migrations.
    \\
    \\Example:
    \\
    \\  jetzig database migrate
    \\  jetzig --environment=testing database migrate
    \\
;

pub fn run(
    allocator: std.mem.Allocator,
    cwd: std.fs.Dir,
    args: []const []const u8,
    options: cli.database.Options,
    T: type,
    main_options: T,
) !void {
    _ = cwd;
    _ = options;
    if (main_options.options.help) {
        try util.stdout.print(help_msg, .{});
        return;
    }

    if (args.len != 0) {
        try util.stderr.print(help_msg, .{});
        return error.JetzigCommandError;
    }

    try util.execCommand(allocator, &.{
        "zig",
        "build",
        util.environmentBuildOption(main_options.options.environment),
        "jetzig:database:migrate",
    });
}
