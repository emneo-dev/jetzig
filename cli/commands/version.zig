const std = @import("std");
const args = @import("args");
const version = @import("version");
const util = @import("../util.zig");

/// Command line options for the `version` command.
pub const Options = struct {
    pub const meta = .{
        .usage_summary = "",
        .full_text = "Print Jetzig version.",
    };
};

/// Run the `jetzig version` command.
pub fn run(
    _: std.mem.Allocator,
    _: Options,
    T: type,
    main_options: T,
) !void {
    if (main_options.options.help) {
        try args.printHelp(Options, "jetzig version", util.stdout);
        return;
    }
    try util.stdout.print("{s}+{s}\n", .{ version.version, version.commit_hash });
}
