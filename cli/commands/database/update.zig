const std = @import("std");

const cli = @import("../../cli.zig");
const util = @import("../../util.zig");

const help_msg =
    \\Update a database: run migrations and reflect schema.
    \\
    \\Convenience wrapper for `jetzig database migrate` and `jetzig database reflect`.
    \\
    \\Example:
    \\
    \\  jetzig database update
    \\  jetzig --environment=testing update
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

    try util.runCommand(allocator, &.{
        "zig",
        "build",
        util.environmentBuildOption(main_options.options.environment),
        "jetzig:database:migrate",
    });

    try util.runCommand(allocator, &.{
        "zig",
        "build",
        util.environmentBuildOption(main_options.options.environment),
        "jetzig:database:reflect",
    });
}
