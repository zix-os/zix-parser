pub const inputs = .{
    .zixpkgs = .{
        .url = "github:zixos/zixpkgs#main",
    },
};

pub fn outputs(flake_inputs: anyopaque) anyopaque {
    return .{
        .devShells = .{
            .default = .{
                .buildInputs = .{
                    flake_inputs.zig,
                },
            },
        },
    };
}
