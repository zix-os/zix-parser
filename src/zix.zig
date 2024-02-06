const std = @import("std");
const AstEmitter = @import("ast_emitter.zig").AstEmitter;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    const file = try std.fs.cwd().readFileAllocOptions(
        allocator,
        "flake.zig",
        std.math.maxInt(usize),
        null,
        1,
        0,
    );
    defer allocator.free(file);

    var ast = try std.zig.Ast.parse(allocator, file, .zig);
    defer ast.deinit(allocator);

    const stdout = std.io.getStdOut().writer();
    var ws = std.json.writeStream(stdout, .{ .whitespace = .indent_2 });
    defer ws.deinit();

    var emit = AstEmitter(@TypeOf(ws)).init(ws, &ast);
    try emit.emitRoot();
}
