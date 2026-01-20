const std = @import("std");
const util = @import("../../util.zig");

const jetquery = @import("jetquery");

const help_msg =
    \\Generate a new Migration. Migrations modify the application's database schema.
    \\
    \\Example:
    \\
    \\  jetzig generate migration create_iguanas
    \\  jetzig generate migration create_iguanas table:create:iguanas column:name:string:index column:age:integer
    \\
    \\  More information: https://www.jetzig.dev/documentation/sections/database/command_line_tools
    \\
;

/// Run the migration generator. Create a migration in `src/app/database/migrations/`
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
    const command = if (args.len > 1)
        try std.mem.join(allocator, " ", args[1..])
    else
        null;

    const migrations_dir = try cwd.makeOpenPath(
        try std.fs.path.join(allocator, &.{ "src", "app", "database", "migrations" }),
        .{},
    );
    const migration = jetquery.Migration.init(
        allocator,
        name,
        .{
            .migrations_path = try migrations_dir.realpathAlloc(allocator, "."),
            .command = command,
        },
    );
    const path = migration.save() catch |err| {
        switch (err) {
            error.InvalidMigrationCommand => {
                try util.stderr.print("Invalid migration command: {?s}", .{command});
                return;
            },
            else => return err,
        }
    };

    try util.stdout.print("Saved migration: {s}", .{path});
}
